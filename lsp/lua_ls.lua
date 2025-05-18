return {
  Lua = {
    diagnostics = {
      globals = { "vim" },
    },
    completion = {
      callSnippet = 'Replace',
    },
    workspace = {
      checkThirdParty = false,
    },
    doc = {
      privateName = { '^_' },
    },
  },
}
