if vim.fn.hostname() ~= 'rivendell' then return {} end

return {
  {
    'nvim-orgmode/orgmode',
    optional = true,
    opts = function(_, opts)
      opts.org_agenda_files = {
        '~/playground/dev/sequoia/**/*.org',
        '~/playground/dev/illumina/ticket_notes/work_org_files/**/*.org',
      }
      opts.org_default_notes_file = '~/playground/dev/sequoia/sequoia_inbox.org'
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    optional = true,
    opts = function(_, opts)
      opts.suggestion.enabled = true
      opts.suggestion.auto_trigger = true
    end
  },
  {
    'supermaven-inc/supermaven-nvim',
    enabled = false,
  }
}
