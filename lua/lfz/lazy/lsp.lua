return {
  {
    "neovim/nvim-lspconfig",
     event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",

      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",

      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",

      "j-hui/fidget.nvim",
    },

    config = function()
      local cmp = require("cmp")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local clangd_cmd = {
          "clangd",
          "--background-index",
        }

      if vim.env.ACTFLOW_HOME then
        local actflow_index = vim.env.ACTFLOW_HOME .. "/actflow.idx"

        if vim.fn.filereadable(actflow_index) == 1 then
          table.insert(
            clangd_cmd,
            "--index-file=" .. actflow_index
          )
        end
      end

      local clangd_fallback_flags = {}

      if vim.env.ACT_HOME then
        table.insert(
          clangd_fallback_flags,
          "-I" .. vim.env.ACT_HOME .. "/include"
        )
      end

      require("fidget").setup({})
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "clangd",
          "pyright",
          "bashls",
          "verible",
        },
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
          },
        },
      })

      vim.lsp.config("clangd", {
          capabilities = capabilities,
          cmd = clangd_cmd,
          init_options = {
            fallbackFlags = clangd_fallback_flags,
          },
        })
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("bashls", { capabilities = capabilities })

      vim.lsp.enable({ "lua_ls", "clangd", "pyright", "bashls","verible","tcl_stage" })

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
      })
    end,
  },
}
