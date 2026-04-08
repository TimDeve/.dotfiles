local utils_vim = require("utils.vim")
local M = {}

local function norg(event)
  return "<Cmd>Neorg keybind norg " .. event .. " <CR>"
end

local function all(event)
  return "<Cmd>Neorg keybind all " .. event .. " <CR>"
end

function M.export_to_clipboard(opts)
  vim.cmd [[ Neorg export to-file /tmp/neorg.md ]]
  if #opts.fargs > 0 and opts.fargs[1] == "rich" then
    vim.cmd [[ ! < /tmp/neorg.md pandoc -s -t html | xclip -t text/html -se c ]]
  else
    vim.cmd [[ ! tmux load-buffer -w /tmp/neorg.md ]]
  end
end

function M.setup()
  require("neorg").setup({
    load = {
      ["core.defaults"] = {},
      ["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
      ["core.export"] = {},
      --["core.tempus"] = {}, -- Needs Nvim 0.10.x
      ["core.concealer"] = {
        config = {
          icon_preset = "basic",
          folds = true,
          icons = {
            todo = {
              done      = { icon = "✓" },
              pending   = { icon = "…" },
              undone    = { icon = " " },
              uncertain = { icon = "~" },
              on_hold   = { icon = "=" },
              cancelled = { icon = "×" },
              recurring = { icon = "↺" },
              urgent    = { icon = "⚠" },
            },
          },
        }
      },
      ["core.dirman"] = {
        config = {
          workspaces = {
            org = os.getenv("HOME") .. "/norg",
            notes = os.getenv("HOME") .. "/notes",
          },
          default_workspace = "org",
        },
      },
      ['core.keybinds'] = {
        config = {
          default_keybinds = true,
        },
      },
      ['core.esupports.indent'] = {
        config = {
          -- dedent_excess = false
        },
      },
      ["external.conceal-wrap"] = {},
      -- MANDATORY
      ["external.many-mans"] = {
          config = {
              metadata_fold = true, -- If want @data property ... @end to fold
              code_fold = true, -- If want @code ... @end to fold
          }
      },
      -- OPTIONAL
      ["external.agenda"] = {
          config = {
              workspace = "org", -- or set to "tasks_workspace" to limit agenda search to just that workspace
          }
      },
    },
  })

  vim.cmd [[ autocmd FileType norg lua require("plugins-config.norg").keybinds() ]]
  vim.cmd [[ autocmd FileType norg setlocal conceallevel=2 ]]
end

function M.keybinds()
  local wk = require("which-key")
  local bufno = vim.api.nvim_get_current_buf()
  wk.add({
    buffer = bufno,
    { "<<", "<Plug>(neorg.promo.demote.nested)", desc = "Unnest" },
    { ">>", "<Plug>(neorg.promo.promote.nested)", desc = "Nest" },
    { "<,", "<Plug>(neorg.promo.demote)", desc = "Unnest" },
    { ">,", "<Plug>(neorg.promo.promote)", desc = "Nest" },
    { "<leader><space>", "<Plug>(neorg.qol.todo-items.todo.task-cycle)", desc = "Task cycle" },
    { "gd", "<Plug>(neorg.esupports.hop.hop-link)", desc = "Hop to link" },

    { "<leader>n", group = "Neorg" },
    { "<leader>nn", "<Plug>(neorg.dirman.new-note)", desc = "New note" },
    { "<leader>no", "<Cmd>Neorg toc split<CR>", desc = "TOC split" },
    { "<leader>nd", "<Plug>(neorg.tempus.insert-date)", desc = "Insert date" },

    { "<leader>nli", "<Plug>(neorg.pivot.invert-list-type)", desc = "List type invert" },
    { "<leader>nlt", "<Plug>(neorg.pivot.toggle-list-type)", desc = "List type toggle" },

    { "<leader>ntc", "<Plug>(neorg.qol.todo-items.todo.task-cancelled)", desc = "Task cancelled" },
    { "<leader>ntd", "<Plug>(neorg.qol.todo-items.todo.task-done)", desc = "Task done" },
    { "<leader>nth", "<Plug>(neorg.qol.todo-items.todo.task-on-hold)", desc = "Task on-hold" },
    { "<leader>nti", "<Plug>(neorg.qol.todo-items.todo.task-important)", desc = "Task important" },
    { "<leader>ntp", "<Plug>(neorg.qol.todo-items.todo.task-pending)", desc = "Task pending" },
    { "<leader>ntr", "<Plug>(neorg.qol.todo-items.todo.task-recurring)", desc = "Task recurring" },
    { "<leader>ntu", "<Plug>(neorg.qol.todo-items.todo.task-undone)", desc = "Task undone" },
    {
      mode = { "v" },
      { "<", "<Plug>(neorg.promo.demote.range)", desc = "Unnest" },
      { ">", "<Plug>(neorg.promo.promote.range)", desc = "Nest" },
    },
  })
end

return M
