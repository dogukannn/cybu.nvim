# Cybu.nvim

**_Cy_**[cle]**_bu_**[ffer]**_.nvim_** provides buffer cycling with contextual preview windows. It offers multiple modes for different workflows:

1. **Default mode**: A wrapper around `:bnext` & `:bprevious` with a customizable notification window showing the buffer in focus and its neighbors.

2. **Last-used mode**: Shows the same contextual window, but with buffers ordered by last used - similar to `[Ctrl] + [Tab]` functionality in web browsers.

3. **Persistent UI mode**: Visual Studio-like behavior where the UI stays open while cycling, allowing you to preview multiple buffers before selecting one.

See [:help cybu.nvim](https://github.com/ghillb/cybu.nvim/blob/main/doc/cybu.nvim.txt) for the docs.

<p align="center">
  <img src="https://user-images.githubusercontent.com/35503959/169406683-6fb0c4dd-2083-4b9b-87b2-3928da81d472.gif" alt="demo1.gif"/>
</p>

<details>
  <summary>More previews</summary>

<p align="center">
  <img src="https://user-images.githubusercontent.com/35503959/169406698-6d5e5eab-88a0-4804-a9a0-4add54d7a368.gif" alt="demo2.gif"/>
</p>

<p align="center">
  <img src="https://user-images.githubusercontent.com/35503959/169406701-aabebcb5-fbcb-4f4e-b43c-ce605d77a8d7.gif" alt="demo3.gif"/>
</p>

</details>

## Requirements

- Neovim >= 0.7.0

## Installation

### Quickstart with [packer](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "ghillb/cybu.nvim",
  branch = "main", -- timely updates
  -- branch = "v1.x", -- won't receive breaking changes
  requires = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim"}, -- optional for icon support
  config = function()
    local ok, cybu = pcall(require, "cybu")
    if not ok then
      return
    end
    cybu.setup()
    vim.keymap.set("n", "K", "<Plug>(CybuPrev)")
    vim.keymap.set("n", "J", "<Plug>(CybuNext)")
    vim.keymap.set({"n", "v"}, "<c-s-tab>", "<plug>(CybuLastusedPrev)")
    vim.keymap.set({"n", "v"}, "<c-tab>", "<plug>(CybuLastusedNext)")
  end,
})
```

After installing, cycle buffers and display the context window by using the exemplary key bindings defined above.

### Setup with other plugin managers

If you use another plugin manager, install `"ghillb/cybu.nvim"` and optionally `"nvim-tree/nvim-web-devicons"` with it, like you would with any other plugin.

Setup up **_Cybu_** by calling its setup function and placing the respective key bindings, somewhere into your `init.lua`.

```lua
require("cybu").setup()
vim.keymap.set("n", "[b", "<Plug>(CybuPrev)")
vim.keymap.set("n", "]b", "<Plug>(CybuNext)")
vim.keymap.set("n", "<s-tab>", "<plug>(CybuLastusedPrev)")
vim.keymap.set("n", "<tab>", "<plug>(CybuLastusedNext)")
```

Hint: If you use the `<tab>` key, map `vim.keymap.set( "n", "<c-i>", "<c-i>")` to keep it separate from `<c-i>` (See: [neovim/pull/17932](https://github.com/neovim/neovim/pull/17932#issue-1188088238)).

## Configuration

If you want to customize the appearance and behaviour of **_Cybu_**, you can do it by adapting the configuration table.

```lua
require("cybu").setup({
  position = {
    relative_to = "win",          -- win, editor, cursor
    anchor = "topcenter",         -- topleft, topcenter, topright,
                                    -- centerleft, center, centerright,
                                    -- bottomleft, bottomcenter, bottomright
    vertical_offset = 10,         -- vertical offset from anchor in lines
    horizontal_offset = 0,        -- vertical offset from anchor in columns
    max_win_height = 5,           -- height of cybu window in lines
    max_win_width = 0.5,          -- integer for absolute in columns
                                    -- float for relative to win/editor width
  },
  style = {
    path = "relative",            -- absolute, relative, tail (filename only),
                                    -- tail_dir (filename & parent dir)
    path_abbreviation = "none",   -- none, shortened
    border = "rounded",           -- single, double, rounded, none
    separator = " ",              -- string used as separator
    prefix = "…",                 -- string used as prefix for truncated paths
    padding = 1,                  -- left & right padding in number of spaces
    hide_buffer_id = true,        -- hide buffer IDs in window
    devicons = {
      enabled = true,             -- enable or disable web dev icons
      colored = true,             -- enable color for web dev icons
      truncate = true,            -- truncate wide icons to one char width
    },
    highlights = {                -- see highlights via :highlight
      current_buffer = "CybuFocus",       -- current / selected buffer
      adjacent_buffers = "CybuAdjacent",  -- buffers not in focus
      background = "CybuBackground",      -- window background
      border = "CybuBorder",              -- border of the window
    },
  },
  behavior = {                    -- set behavior for different modes
    mode = {
      default = {
        switch = "immediate",     -- immediate, on_close, on_key_release
        view = "rolling",         -- paging, rolling
      },
      last_used = {
        switch = "on_close",      -- immediate, on_close, on_key_release
        view = "paging",          -- paging, rolling
        update_on = "buf_enter",  -- buf_enter, cursor_moved
      },
      auto = {
        view = "rolling",         -- paging, rolling
      },
    },
    show_on_autocmd = false,      -- event to trigger cybu (eg. "BufEnter")
    persistent_ui = {             -- Visual Studio-like persistent UI
      enabled = false,            -- enable persistent UI mode
      timeout = 2000,             -- timeout in ms before auto-close
    },
  },
  display_time = 750,             -- time the cybu window is displayed
  exclude = {                     -- filetypes, cybu will not be active
    "neo-tree",
    "fugitive",
    "qf",
  },
  filter = {
    unlisted = true,              -- filter & fallback for unlisted buffers
  },
  fallback = function() end,      -- arbitrary fallback function
                                    -- used in excluded filetypes
})
```

## Features

- Two modes: cycle `:buffers` list or cycle last used buffers
- **Cursor-based MRU ordering**: Control when buffers are marked as "used"
- Adaptive size of the **_Cybu_** window
- Various styling & positioning options
- Exclude filetypes and define fallback
- Autocmd events `CybuOpen` & `CybuClose`
- Trigger context window on arbitrary autocommand events
- **Persistent UI Mode**: Visual Studio-like Ctrl+Tab behavior

### Persistent UI Mode (Visual Studio-like Ctrl+Tab)

Cybu supports a persistent UI mode that keeps the buffer selection window open while you cycle through buffers, similar to Visual Studio's Ctrl+Tab behavior.

```lua
require("cybu").setup({
  behavior = {
    mode = {
      last_used = {
        switch = "on_key_release",  -- Required for persistent UI
        view = "paging",
        update_on = "buf_enter",
      },
    },
    persistent_ui = {
      enabled = true,
      timeout = 2000,  -- UI stays open for 2 seconds of inactivity
    },
  },
})

-- Keymaps for Ctrl+Tab behavior
vim.keymap.set("n", "<C-Tab>", function()
  require("cybu").cycle("next", "last_used")
end, { desc = "Next buffer (persistent UI)" })

vim.keymap.set("n", "<C-S-Tab>", function()
  require("cybu").cycle("prev", "last_used")  
end, { desc = "Previous buffer (persistent UI)" })
```

**How it works:**
- Press `Ctrl+Tab` to open the UI and cycle to the next buffer
- The UI stays open as you continue pressing `Ctrl+Tab`/`Ctrl+Shift+Tab`
- The UI automatically closes after the timeout period (default 2 seconds)
- Any other action (cursor movement, insert mode, etc.) immediately closes the UI
- When the UI closes, it switches to the currently selected buffer

See [`examples/persistent_ui.lua`](examples/persistent_ui.lua) for a complete configuration example.

### Advanced: Cursor Movement Based MRU

The `update_on` option in `last_used` mode controls when buffers are moved to the most recently used position:

- `"buf_enter"` (default): Updates MRU order on every buffer switch
- `"cursor_moved"`: Only updates MRU when cursor moves in the buffer
- `"text_changed"`: Only updates MRU when text is actually edited

```lua
require("cybu").setup({
  behavior = {
    mode = {
      last_used = {
        update_on = "text_changed",
      }
    }
  }
})
```

### Experimental: Custom Buffer Providers

**⚠️ Experimental Feature**: This feature is experimental and the API may change in future versions. Use with caution in production environments.

You can integrate cybu with other buffer management plugins like [grapple.nvim](https://github.com/cbochs/grapple.nvim) or [harpoon.nvim](https://github.com/ThePrimeagen/harpoon) by providing a custom buffer provider function:

```lua
require("cybu").setup({
  experimental = {
    buffer_provider = function()
      -- Return table of buffer objects: {{bufnr=1, filename="file.lua"}, ...}
      -- Logic to fetch buffers from your preferred source
      return custom_buffer_list
    end
  }
})
```

See `examples/buffer_providers.lua` for working examples with grapple.nvim, harpoon.nvim, and advanced usage patterns.

## Breaking changes

If breaking changes (will be kept to a minimum) are of no concern to you, use the `main` branch. Otherwise you can use the version pinned branches, e.g. `v1.x`. These branches will only receive bug fixes and other non-breaking changes.

## Roadmap

- Add possibility to further customize the entry layout
- Offer additional modes to cycle buffers

## Testing via [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)

Run tests with

```bash
make tests
```
