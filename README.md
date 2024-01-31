<h1 align="center">
  marknav.nvim
</h1>

<div><h4 align="center"><a href="#installation">Installation</a> · <a href="#setup">Setup</a> · <a href="#usage">Usage</h4></div>


<div align="center">
<img alt="GitHub License" src="https://img.shields.io/github/license/daenikon/marknav.nvim?style=for-the-badge&logo=license&labelColor=303335&color=8bc6f9">
<img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/daenikon/marknav.nvim?style=for-the-badge&logo=github&labelColor=303335&color=f8f98b">
<img alt="Static Badge" src="https://img.shields.io/badge/Lua-built%20with%20Lua-%23a9abfc?style=for-the-badge&logo=lua&logoColor=%23ffffff&labelColor=303335">
<img alt="Static Badge" src="https://img.shields.io/badge/neovim-v.0.5.0%2B-%238bf99c?style=for-the-badge&logo=neovim&logoColor=%23ffffff&labelColor=303335">
</div>

<hr>

A Neovim plugin for navigating markdown links, written in pure Lua.

Intended to be minimal and simple to use. Made with Neovim built-in features in mind and no dependencies.

![DEMO GIF](https://github.com/daenikon/marknav.nvim/assets/91436186/867a3712-0360-4b9c-9353-250fb6d0fb2e)


## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{ 'daenikon/marknav.nvim' }
```
### [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use "daenikon/marknav.nvim"
```
### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'daenikon/marknav.nvim'
```

## Setup

To initialize marknav, run the `setup` function.

```lua
require("marknav").setup()
```

## Usage
All commands and keybinds are available exclusively in Markdown files.
| Command          | Default Keybind        | Description                                                  |
|------------------|------------------------|--------------------------------------------------------------|
| `:MarknavJump`   | **Enter**              | Open a link under cursor                                     |
| `:MarknavTab`    | **\<Leader\> + Enter** | Open a link under cursor in a new tab                        |
| `:MarknavBack`   | **Backspace**          | Go back to previous file                                     |

Do not forget to set \<Leader\> in your `init.lua` (e.g. set to **space** - `vim.g.mapleader = " "`)

