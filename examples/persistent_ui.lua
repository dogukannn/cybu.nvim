-- Example configuration for persistent UI mode (Visual Studio-like Ctrl+Tab behavior)
-- This configuration allows the cybu UI to stay open while you cycle through buffers

local cybu = require("cybu")

-- Configuration for persistent UI behavior
cybu.setup({
  behavior = {
    mode = {
      -- Configure default mode to use on_key_release switch
      default = {
        switch = "on_key_release",  -- Switches buffer when UI closes
        view = "rolling",
      },
      -- last_used mode also supports persistent UI  
      last_used = {
        switch = "on_key_release",  -- Switches buffer when UI closes
        view = "paging",
        update_on = "buf_enter",
      },
    },
    -- Enable persistent UI mode
    persistent_ui = {
      enabled = true,
      timeout = 2000,  -- UI stays open for 2 seconds of inactivity (in ms)
    },
  },
  -- Increase display time for better experience with persistent UI
  display_time = 1500,
})

-- Keymaps for Visual Studio-like Ctrl+Tab behavior
-- The UI will stay open while you press Ctrl+Tab repeatedly
vim.keymap.set("n", "<C-Tab>", function()
  require("cybu").cycle("next", "last_used")
end, { desc = "Next buffer (persistent UI)" })

vim.keymap.set("n", "<C-S-Tab>", function()
  require("cybu").cycle("prev", "last_used")
end, { desc = "Previous buffer (persistent UI)" })

-- Alternative keymaps for default mode (non-last-used)
vim.keymap.set("n", "<leader><Tab>", function()
  require("cybu").cycle("next", "default")
end, { desc = "Next buffer (persistent UI, default mode)" })

vim.keymap.set("n", "<leader><S-Tab>", function()
  require("cybu").cycle("prev", "default")
end, { desc = "Previous buffer (persistent UI, default mode)" })

--[[
How it works:

1. When you press Ctrl+Tab, the cybu UI opens showing all buffers
2. The UI stays open as long as you keep cycling with Ctrl+Tab/Ctrl+Shift+Tab
3. The UI automatically closes after 2 seconds of inactivity (configurable)
4. When the UI closes, it switches to the selected buffer
5. Any other action (cursor movement, entering insert mode, etc.) also closes the UI

This provides a Visual Studio-like experience where you can:
- Press and hold Ctrl, then tap Tab repeatedly to cycle through buffers
- See all available buffers while cycling
- Release Ctrl (or wait/do other actions) to switch to the selected buffer
--]]