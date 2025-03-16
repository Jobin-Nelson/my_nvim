local M = {}

function M.stop_inactive_lsp()
  local active_lsp_ids = vim.tbl_map(function(lsp)
    return lsp.id
  end, vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf()
  }))
  local inactive_lsps = vim.tbl_filter(function(lsp)
    return not vim.list_contains(active_lsp_ids, lsp.id)
  end, vim.lsp.get_clients())
  vim.lsp.stop_client(inactive_lsps)
  vim.notify("All Inactive LSP's are stopped", vim.log.levels.INFO, { title = 'Utils' })
end

function M.get_all_lsp()
  local lsp_names = vim.tbl_map(function(lsp) return lsp.name end, vim.lsp.get_clients())
  vim.notify(
    ("LSP: %s"):format(table.concat(lsp_names, ', ')),
    vim.log.levels.INFO,
    { title = 'Utils' }
  )
end

function M.stop_lsp()
  local lsps_except_copilot = vim.tbl_filter(function(lsp)
    return lsp.name ~= 'copilot'
  end, vim.lsp.get_clients())
  vim.lsp.stop_client(lsps_except_copilot)
  vim.notify("All LSP's are stopped", vim.log.levels.INFO, { title = 'Utils' })
end

return M
