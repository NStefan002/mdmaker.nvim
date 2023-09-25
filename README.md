# ⚒️ MdMaker
>README.md generator for your Neovim config repo. Created for lazy people like me.

## 📺 Showcase

[MdMaker_showcase.webm](https://github.com/NStefan002/mdmaker.nvim/assets/100767853/1c2103e3-2b11-4e90-9c18-69884fd5c837)

## ✨ Features
* **Generate README.md file** - Run `:MdMake` and it's done
* **Create urls for plugin repositories and sort them alphabetically**
* **Optional** - Include Neovim version manager and GUI of your choice

## ⚙ Configuration

<details>
<summary>Full list of options with their default values</summary>

```lua
{
    nvim_dir = "~/.config/nvim/",
    output = "~/.config/nvim/README.md",
    package_maganer = "folke/lazy.nvim",
    -- NOTE: curl is required if enable_url_check is set to true
    enable_url_check = false, -- greatly slows down neovim for few seconds, use it when you REALLY need it
    -- if you don't want any of the following fields, set them to ""
    title = "Neovim configuration",
    version_manager = { name = "", url = "" },
    gui = { name = "", url = "" },
}

```

</details>

## ⚠️ Warning
MdMaker goes through your Neovim configuration files and finds the plugins repo names, generates url and creates README.md file.
This plugin was only tested on Linux systems and it was created for my personal use.
I shared it so someone can fork it and customize according to their personal needs.
