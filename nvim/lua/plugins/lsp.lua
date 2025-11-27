return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyrefly = {
          enabled = true,
        },
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
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "pyrefly",
        "ruff",
        "debugpy",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        python = { "ruff_format", "ruff_fix" },
      },
    },
  },
}
