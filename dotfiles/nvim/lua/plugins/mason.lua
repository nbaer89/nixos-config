return {
  {
    "williamboman/mason.nvim",
    opts = {
      PATH = "skip",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {},
      auto_update = false,
      run_on_start = false,
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {},
      automatic_enable = false,
      automatic_installation = false,
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {},
      automatic_installation = false,
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    opts = {
      ensure_installed = {},
      automatic_installation = false,
    },
  },
}
