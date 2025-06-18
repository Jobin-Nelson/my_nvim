return {
  {
    'nvim-orgmode/orgmode',
    cmd = {
      'Org',
    },
    keys = {
      { "<leader>o",  "",                    desc = "+Org Mode" },
      { "<leader>oa", "<cmd>Org agenda<cr>", desc = "org agenda" },
    },
    ft = { 'org' },
    opts = {
      org_agenda_files = {
        '~/playground/org_files/**/*.org',
      },
      org_default_notes_file = '~/playground/org_files/inbox.org',
      org_todo_keywords = { 'TODO(t)', 'NEXT(n)', 'WAITING(w)', 'REVIEW(r)', '|', 'DONE(d)', 'CANCELLED(c)', 'DELEGATED(e)' },
      -- org_archive_location = '~/playground/org_files/archive_file.org_archive',
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
          org_forward_heading_same_level = ']}',
          org_backward_heading_same_level = '[{',
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
      org_agenda_custom_commands = {
        -- "c" is the shortcut that will be used in the prompt
        c = {
          description = 'Combined view', -- Description shown in the prompt for the shortcut
          types = {
            {
              type = 'tags_todo',                       -- Type can be agenda | tags | tags_todo
              match = '+PRIORITY="A"',                  --Same as providing a "Match:" for tags view <leader>oa + m, See: https://orgmode.org/manual/Matching-tags-and-properties.html
              org_agenda_overriding_header = 'High priority todos',
              org_agenda_todo_ignore_deadlines = 'far', -- Ignore all deadlines that are too far in future (over org_deadline_warning_days). Possible values: all | near | far | past | future
            },
            {
              type = 'agenda',
              org_agenda_overriding_header = 'My daily agenda',
              org_agenda_span = 'day' -- can be any value as org_agenda_span
            },
            {
              type = 'tags',
              match = 'WORK',                           --Same as providing a "Match:" for tags view <leader>oa + m, See: https://orgmode.org/manual/Matching-tags-and-properties.html
              org_agenda_overriding_header = 'My work todos',
              org_agenda_todo_ignore_scheduled = 'all', -- Ignore all headlines that are scheduled. Possible values: past | future | all
            },
            {
              type = 'agenda',
              org_agenda_overriding_header = 'Whole week overview',
              org_agenda_span = 'week',        -- 'week' is default, so it's not necessary here, just an example
              org_agenda_start_on_weekday = 1, -- Start on Monday
              org_agenda_remove_tags = true    -- Do not show tags only for this view
            },
          }
        },
      }
    },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources.providers.orgmode = {
        name = 'Orgmode',
        module = 'orgmode.org.autocompletion.blink',
      }
      opts.sources.per_filetype.org = { 'snippets', 'orgmode', 'path', 'buffer' }
    end,
  }
}
