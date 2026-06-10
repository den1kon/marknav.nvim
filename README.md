<h1 align="center">
  slipnote.nvim
</h1>

<div><h4 align="center"><a href="#installation">Installation</a> · <a href="#setup">Setup</a> · <a href="#usage">Usage</h4></div>


<div align="center">
<img alt="GitHub License" src="https://img.shields.io/github/license/den1kon/slipnote.nvim?style=for-the-badge&logo=license&labelColor=303335&color=8bc6f9">
<img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/den1kon/slipnote.nvim?style=for-the-badge&logo=github&labelColor=303335&color=f8f98b">
<img alt="Built with Lua" src="https://img.shields.io/badge/Lua-built%20with%20Lua-%23a9abfc?style=for-the-badge&logo=lua&logoColor=%23ffffff&labelColor=303335">
<img alt="Neovim v0.5.0+" src="https://img.shields.io/badge/neovim-v.0.5.0%2B-%238bf99c?style=for-the-badge&logo=neovim&logoColor=%23ffffff&labelColor=303335">
</div>

<hr>

A Neovim plugin designed to enhance your Markdown navigation experience.

Leveraging the power of Lua and Neovim built-in features, it offers an efficient way to follow links within Markdown documents, without the need for external dependencies.
Intended to be minimal, fast, and simple to use. 

![DEMO GIF](https://github.com/den1kon/slipnote.nvim/assets/91436186/867a3712-0360-4b9c-9353-250fb6d0fb2e)


## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "den1kon/slipnote.nvim",
  ft = { "markdown", "md" },
  config = function()
    require("slipnote").setup()
  end
}
```
### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use "den1kon/slipnote.nvim"
```
### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'den1kon/slipnote.nvim'
```

## Setup
After installation, initialize slipnote by adding the following to your Neovim configuration:

```lua
require("slipnote").setup()
```

The above line is redundant with the provided config for lazy.nvim.

## Usage
`slipnote.nvim` is designed to work exclusively within Markdown files, offering the following commands:
| Command            |  Description                                                            |
|--------------------|-------------------------------------------------------------------------|
| `:FollowLink`     |  Jump to the link under the cursor.                                     |
| `:FollowBack`     |  Navigate back to the previous file.                                    |
| `:FollowLinkInNewTab`      |  Jump to the link under the cursor in a new tab                         |

