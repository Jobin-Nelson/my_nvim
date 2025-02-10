return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('orgmode').setup({
      org_agenda_files = {
        '~/playground/projects/org_files/**/*.org',
        '~/playground/dev/illumina/ticket_notes/work_org_files/**/*.org',
      },
      org_default_notes_file = '~/playground/projects/org_files/inbox.org',
      org_todo_keywords = { 'TODO(t)', 'NEXT(n)', 'WAITING(w)', 'REVIEW(r)', '|', 'DONE(d)', 'CANCELLED(c)', 'DELEGATED(e)' },
      -- org_archive_location = '~/playground/projects/org_files/archive_file.org_archive',
      org_todo_repeat_to_state = 'NEXT',
      org_startup_folded = 'content',
      org_hide_leading_stars = false,
      org_hide_emphasis_markers = true,
      org_agenda_span = 'day',
      org_blank_before_new_entry = { heading = true, plain_list_item = false },
      org_log_into_drawer = 'LOGBOOK',
      org_use_tag_inheritance = false,
      mappings = {
        org_return_uses_meta_return = true,
        org = {
          org_forward_heading_same_level = ']n',
          org_backward_heading_same_level = '[p',
        },
      },
      org_capture_templates = {
        m = {
          description = 'Meeting',
          template = '\n* %?\n  %u',
          target = '~/playground/dev/illumina/ticket_notes/work_org_files/ICI/ici-on-prem/meeting_notes.org',
        },
        w = {
          description = 'Work Task',
          template = '\n* TODO %?\n  SCHEDULED: %t',
          target = '~/playground/dev/illumina/ticket_notes/work_org_files/work_inbox.org',
        }
      },
    })

    -- for _, key in ipairs({ '=', '~' }) do
    --   vim.keymap.set('v', 'i' .. key, string.format('t%soT%s', key, key), { desc = string.format('inner org %s', key) })
    --   vim.keymap.set('v', 'a' .. key, string.format('f%soF%s', key, key), { desc = string.format('around org %s', key) })
    --   vim.keymap.set('o', 'i' .. key, string.format('<cmd>normal! t%svT%s<CR>', key, key), { desc = string.format('inner org %s', key) })
    --   vim.keymap.set('o', 'a' .. key, string.format('<cmd>normal! f%svF%s<CR>', key, key), { desc = string.format('around org %s', key) })
    -- end
  end
}
