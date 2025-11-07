return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "python",
        "lua",
        "json",
        "toml",
        "bash",
        "yaml",
        "xml",
        "sql",
        "markdown",
      },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
    },
  },
}
