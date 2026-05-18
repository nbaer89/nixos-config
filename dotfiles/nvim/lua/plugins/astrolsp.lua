return {
  "AstroNvim/astrolsp",
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
      },
      timeout_ms = 1000,
    },
    servers = {
      "basedpyright",
      "lua_ls",
      "nixd",
      "ruff",
      "rust_analyzer",
    },
    config = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      },
    },
  },
}
