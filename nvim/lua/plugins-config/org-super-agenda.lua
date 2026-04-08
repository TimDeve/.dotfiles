local M = {}

function M.setup()
  local palette = require("gruvbox").palette
  vim.keymap.set("n", "<leader>os", ":OrgSuperAgenda<CR>")

  require('org-super-agenda').setup({
      org_directories = {'~/notes'},
      show_other_group   = true,
      todo_states = {
        { name='TODO', keymap='ot', color="",                   strike_through=false, fields={'filename','todo','headline','priority','date','tags'} },
        { name='WIP', keymap='op', color=palette.bright_yellow, strike_through=false, fields={'filename','todo','headline','priority','date','tags'} },
        { name='DONE', keymap='od', color=palette.bright_green,  strike_through=true,  fields={'filename','todo','headline','priority','date','tags'} },
      },
      groups = {
        { name = ' Today',      matcher = function(i) return i.scheduled and i.scheduled:is_today() end, sort={ by='priority', order='desc' } },
        { name = ' Tomorrow',   matcher = function(i) return i.scheduled and i.scheduled:days_from_today() == 1 end },
        { name = ' Deadlines', matcher = function(i) return i.deadline and i.todo_state ~= 'DONE' and not i:has_tag('personal') end, sort={ by='deadline', order='asc' } },
        { name = ' Important',  matcher = function(i) return i.priority == 'A' and (i.deadline or i.scheduled) end, sort={ by='date_nearest', order='asc' } },
        { name = ' Overdue',    matcher = function(i) return i.todo_state ~= 'DONE' and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past())) end, sort={ by='date_nearest', order='asc' } },
        { name = '󰋑 Personal',   matcher = function(i) return i:has_tag('personal') end },
        { name = ' Work',      matcher = function(i) return i:has_tag('work') end },
        { name = '↪ Upcoming',   matcher = function(i)
            local days = require('org-super-agenda.config').get().upcoming_days or 10
            local d1 = i.deadline  and i.deadline:days_from_today()
            local d2 = i.scheduled and i.scheduled:days_from_today()
            return (d1 and d1 >= 0 and d1 <= days) or (d2 and d2 >= 0 and d2 <= days)
          end,
          sort={ by='date_nearest', order='asc' }
        },
      },
  })
end

return M
