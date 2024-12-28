return {
  'nvim-java/nvim-java',
  ft = 'java',
  dependencies = {
    'nvim-neotest/neotest',
    "rcasia/neotest-java",
  },
  config = function()
    -- blink.cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    -- for ufo
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }
    require('java').setup()
    require('lspconfig').jdtls.setup({
      capabilities = capabilities,
    })

    ---@diagnostic disable-next-line: missing-fields
    require('neotest').setup({
      adapters = {
        require("rcasia/neotest-java")
      }
    })
  end
}
