# 🍹 `caipirinha.nvim`

A blazingly fast and effortless colorscheme manager

## ✨ Features

- Persistant colorscheme selection with live preview
- Popular picker integrations (fzf-lua, telescope, mini.pick, snacks.picker)

## ⚡️ Requirements

> [!WARNING]
> Requires `Neovim >= 0.10`

- for icons support:
  - [mini.icons](https://github.com/echasnovski/mini.icons) _(optional)_
  - [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) _(optional)_
  - a [Nerd Font](https://www.nerdfonts.com/) _(optional)_
- at least one of these for the picker:
  - nui _(optional)_
  - fzf-lua _(optional)_
  - telescope _(optional)_
  - mini.pick _(optional)_
  - snacks.picker _(optional)_

## 📦 Installation

Install the plugin with your package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'joaoinez/caipirinha.nvim',
  priority = 1001,
  lazy = false,
  --@type caipirinha.Options
  opts = {}
}
```

## ⚙️ Configuration

WIP

## 🚀 Usage

WIP

## Roadmap

- [x] Switch colorscheme
  - [x] fzf-lua integration
  - [x] telescope integration
  - [x] mini.pick integration
  - [x] snacks.picker integration
  - [x] custom ui
- [x] Colorscheme persistance
- [x] Random colorscheme on startup
- [x] Robust user commands
- [ ] README / Documentation
- [x] Types / docstrings
- [ ] Better filtering, like dark/light themes, etc
- [ ] Remote colorschemes
- [ ] Merge local, remote and url colorschemes
- [ ] Multiple selection
- [ ] Pickers' options
- [ ] Tests
- [ ] Favourite colorschemes
- [ ] Project specific colorschemes
- [ ] VimResized handling
- [ ] Add colorscheme from url
- [ ] Add vim events so users can listen to them

## Alternatives

WIP

<a href="https://star-history.com/#joaoinez/caipirinha.nvim&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=joaoinez/caipirinha.nvim&type=Date&theme=dark"/>
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=joaoinez/caipirinha.nvim&type=Date"/>
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=joaoinez/caipirinha.nvim&type=Date"/>
  </picture>
</a>
