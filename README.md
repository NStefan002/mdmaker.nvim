# ⚒️ MdMaker

> README.md generator for your Neovim configuration repo. Created for lazy people like me.

# NOTE

THIS PLUGIN IS NOW **ARCHIVED**, IF YOU WANT TO ACHIEVE THE SAME RESULT (USING LAZY.NVIM),
CHECK OUT [THIS](https://www.reddit.com/r/neovim/comments/1cfyx4p/generate_readme_for_your_nvim_config_repository/) POST I WROTE ON REDDIT.

## 📺 Showcase

[mdmaker_showcase.webm](https://github.com/NStefan002/mdmaker.nvim/assets/100767853/cb2fe8d8-725b-4ddb-8940-4586bf40f441)

#### Used in the showcase:

- [mdmaker.nvim](https://github.com/NStefan002/mdmaker.nvim)
- [markdown-preview](https://github.com/iamcco/markdown-preview.nvim)
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)

**Note**: to see the example of a generated readme go to my [Neovim config](https://github.com/NStefan002/nvim_config)

## ✨ Features

- **Generate README.md file** - Run `:MdMake` and it's done
- **Create URLs for plugin repositories and sort them alphabetically**
- **Optional** - Include the Neovim version manager and GUI of your choice

## 📋 Installation

[lazy](https://github.com/folke/lazy.nvim):

```lua
{
    "NStefan002/mdmaker.nvim",
    cmd = "MdMake",
    opts = {
    -- your config
    }
}
```

[packer](https://github.com/wbthomason/packer.nvim):

```lua
use({
    "NStefan002/mdmaker.nvim",
    config = function()
        require("mdmaker").setup({
            -- your config
        })
    end,
})
```

#### ✔️ Dependencies

- **_curl_** (only if `enable_url_check` is set to true)
- **_Neovim nightly_** (only if `enable_url_check` is set to true)
- **_Neovim version 0.9.1 and above_** (might work with earlier versions but it's not tested)

## ⚙ Configuration

<details>
<summary>Full list of options with their default values</summary>

```lua
{
    nvim_dir = "~/.config/nvim/",
    output = "~/.config/nvim/README.md",
    enable_url_check = false, -- disable if generating README.md offline or with a bad connection
    package_maganer = "folke/lazy.nvim",
    -- If you don't want any of the following fields, set them to ""
    title = "Neovim configuration",
    version_manager = { name = "", url = "" },
    gui = { name = "", url = "" },
}

```

</details>

## ⚠️ Warning

- MdMaker goes through your Neovim configuration files and finds the plugin repo
  names, generates URLs, and creates a README.md file.
  Because it is using lua patterns to match the plugin names, it could (rarely)
  make a mistake (for example if you have a string `"some_non-blank_characters/same_thing"`
  in your config that is inside of a comment or something similar).
  If that happens consider enabling the `enable_url_check` option. It will take some
  time to finish (1-10 sec on avg. depending on the number of plugins, internet speed, etc.).
  Note that while it validates URLs, It **WILL NOT** block your Neovim instance! It will
  work in the background and notify you when your README is generated.
- This plugin was only tested on Linux systems.
- This plugin was created for my personal use (since I'm a lazy bastard).
  I shared it so someone can fork it and customize it according to their personal needs if they
  don't like my 'style' of writing READMEs (e.g. icon choice, sorting order of plugins, etc.).
