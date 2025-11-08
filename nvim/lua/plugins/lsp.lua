return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Pyright configuration
        pyright = {
          enabled = true,
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic", -- Can be "off", "basic", or "strict"
              },
            },
          },
        },
        -- Ruff LSP configuration
        ruff = {
          enabled = true,
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
        },
      },
    },
  },

  -- Configure none-ls with Ruff
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}

      -- Add Ruff for formatting and linting via none-ls
      vim.list_extend(opts.sources, {
        -- Ruff linting
        nls.builtins.diagnostics.ruff.with({
          extra_args = { "--extend-select", "I" }, -- Enable import sorting
        }),
        -- Ruff formatting
        nls.builtins.formatting.ruff.with({
          extra_args = { "--line-length", "88" }, -- Match Black's default
        }),
        -- Optional: Add Ruff for import sorting
        nls.builtins.formatting.ruff_format,
      })

      return opts
    end,
  },

  -- Configure Mason to ensure tools are installed
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "ruff",
        "ruff-lsp",
        "debugpy", -- For debugging
      },
    },
  },

  -- Optional: Configure format on save
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_fix" },
      },
    },
  },

  -- Optional: Configure nvim-lint
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        python = { "ruff" },
      },
    },
  },
}
