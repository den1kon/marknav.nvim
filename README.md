<h1 align="center">
  marknav.nvim
</h1>

<p align="center">Markdown link navigation for Neovim written in pure lua.</p>

![DEMO GIF](https://github.com/daenikon/marknav.nvim/assets/91436186/fa9e1b0d-0c60-4496-a491-3bf5148a8a76)

###### :exclamation: **IMPORTANT**: Windows OS is not supported yet. Unix-like OS only (MacOS, GNU/Linux...)

- [Installation](#installation)
- [Setup](#setup)
- [Usage](#usage)

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
| `:MarknavJumpTo` | **\<Leader\> + m**     | Follow nth link (opens interactive dialog at the bottom)     |

Do not forget to set \<Leader\> in your `init.lua` (e.g. set to **space** - `vim.g.mapleader = " "`)

