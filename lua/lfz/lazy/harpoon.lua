return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
      local harpoon = require("harpoon")

      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      })

      -- Add current file
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end, { desc = "Harpoon add file" })

      -- Open Harpoon menu
      vim.keymap.set("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon menu" })

      -- QWERTY home-row file jumps
      vim.keymap.set("n", "<C-h>", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon file 1" })

      vim.keymap.set("n", "<C-j>", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon file 2" })

      vim.keymap.set("n", "<C-k>", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon file 3" })

      vim.keymap.set("n", "<C-l>", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon file 4" })

      vim.keymap.set("n", "<C-;>", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon file 5" })

      -- Cycle through Harpoon list
      vim.keymap.set("n", "<C-S-P>", function()
        harpoon:list():prev()
      end, { desc = "Harpoon previous" })

      vim.keymap.set("n", "<C-S-N>", function()
        harpoon:list():next()
      end, { desc = "Harpoon next" })
    end,
  },
}

