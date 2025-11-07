return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              diagnosticMode = "off",
            },
          },
        },
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = { logLevel = "error" },
          },
        },
      },
      setup = {
        ruff = function()
          require("lazyvim.util").lsp.on_attach(function(client, _)
            client.server_capabilities.hoverProvider = false
          end, "ruff")
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "pyright" then
            client.server_capabilities.documentFormattingProvider = false
          end
        end,
      })

      local format_group = vim.api.nvim_create_augroup("PythonFormatOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        pattern = "*.py",
        callback = function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.organizeImports" },
              diagnostics = {},
            },
          })
          vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
        end,
      })
    end,
  },
}
