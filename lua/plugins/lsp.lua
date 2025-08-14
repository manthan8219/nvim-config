return {
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim", -- auto-install LSPs
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "jdtls" }, -- Java LSP
      })
    end,
  },

  -- Java-specific LSP
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local home = os.getenv("HOME")
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

      local config = {
        cmd = {
          "jdtls", -- must be in PATH (installed via mason)
          "-data", workspace_dir
        },
        root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
      }

      require("jdtls").start_or_attach(config)
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
      })
    end,
  },
}

