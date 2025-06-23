if vim.fn.hostname() ~= 'rivendell' then return {} end

vim.keymap.set('n', '<leader>foT', function()
  require("jobin.config.custom.fzf.pickers").fzf_org_live_grep("~/playground/dev/illumina/ticket_notes/work_org_files")
end, { desc = 'Org Todo grep (Work)' })

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
      opts.org_capture_templates.m = {
        description = 'Meeting',
        template = '\n* %?\n  %u',
        target = '~/playground/dev/illumina/ticket_notes/work_org_files/ICI/ici-on-prem/meeting_notes.org',
      }
      opts.org_capture_templates.w = {
        description = 'Work Task',
        template = '\n* TODO %?\n  SCHEDULED: %t',
        target = '~/playground/dev/illumina/ticket_notes/work_org_files/work_inbox.org',
      }
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
