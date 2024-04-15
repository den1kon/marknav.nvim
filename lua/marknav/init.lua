local BufferManager = require("marknav.buffer_manager") 
local CmdHandler = require("marknav.command_handler")

local M = {}

-- Set up commands for Markdown file navigation
function M.setup(user_config)
  user_config = user_config or { use_default_keybinds = true }
  
  local augroup = vim.api.nvim_create_augroup("MarknavAutocommands", { clear = true })

  -- Update buffer every time the buffer or window is entered, while in markdown file
  vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
    group = augroup,
    pattern = {"*.md", "*.markdown"},
    callback = BufferManager.handle_stack
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "markdown",
    callback = function()
      -- Set conceal options for syntax
      vim.opt_local.conceallevel = 2
      -- Set tab to 2 spaces
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
      vim.opt_local.expandtab = true

      -- User Commands
      vim.api.nvim_create_user_command('MarknavJump', CmdHandler.forward_jump, {nargs = 0})
      vim.api.nvim_create_user_command('MarknavBack', CmdHandler.back_jump, {nargs = 0})
      vim.api.nvim_create_user_command('MarknavTab', CmdHandler.forward_tab_jump, {nargs = 0})

      -- Keybindings
      if user_config.use_default_keybinds then
        local opts = { noremap = true, silent = true }
        vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', ':MarknavJump<CR>', opts)
        vim.api.nvim_buf_set_keymap(0, 'n', '<BS>', ':MarknavBack<CR>', opts)
        vim.api.nvim_buf_set_keymap(0, 'n', '<Leader><CR>', ':MarknavTab<CR>', opts)
      end
    end,
  })
end

return M
