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
    codelens = {
      enable = true,
    },
    doc = {
      privateName = { '^_' },
    },
    hint = {
      enable = true,
      setType = false,
      paramType = true,
      paramName = "Disable",
      semicolon = "Disable",
      arrayIndex = "Disable",
    },
  },
}
