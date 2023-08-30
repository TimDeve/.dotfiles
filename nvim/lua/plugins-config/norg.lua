local M = {}

local function norg(event)
  return "<Cmd>Neorg keybind norg " .. event .. " <CR>"
end

local function all(event)
  return "<Cmd>Neorg keybind all " .. event .. " <CR>"
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
            notes = os.getenv("HOME") .. "/notes",
          },
          default_workspace = "notes",
        },
      },
      ['core.keybinds'] = {
        config = {
          keybind_preset = 'none',
        },
      },
    },
  })

  vim.cmd [[ autocmd FileType norg lua require("plugins-config.norg").keybinds() ]]
  vim.cmd [[ autocmd FileType norg setlocal conceallevel=2 ]]
end

function M.keybinds()
  local wk = require("which-key")
  local bufno = vim.api.nvim_get_current_buf()
  wk.register(
    {
      ["<leader>"] = {
        ["<space>"] = { norg("core.qol.todo_items.todo.task_cycle"), "Task cycle" },
        n = {
          name = "Neorg",

          lt = { norg("core.pivot.toggle-list-type"), "List type toggle" },
          li = { norg("core.pivot.invert-list-type"), "List type invert" },
          --t  = { norg("core.tempus.insert-date"),     "Date insert" }, -- Needs core.tempus

          n = { norg("core.dirman.new.note"), "New note" },
          t = { "<Cmd>Neorg toc split<CR>",   "TOC split" },

          -- Task
          u = { norg("core.qol.todo_items.todo.task_undone"),      "Task undone" },
          p = { norg("core.qol.todo_items.todo.task_pending"),     "Task pending" },
          d = { norg("core.qol.todo_items.todo.task_done"),        "Task done" },
          h = { norg("core.qol.todo_items.todo.task_on_hold"),     "Task on-hold" },
          c = { norg("core.qol.todo_items.todo.task_cancelled"),   "Task cancelled" },
          r = { norg("core.qol.todo_items.todo.task_recurring"),   "Task recurring" },
          i = { norg("core.qol.todo_items.todo.task_important"),   "Task important" },
          --a = { norg("core.qol.todo_items.todo.task_ambiguous"), "Task ambiguous" }, -- Doesn't exists?
       },
      },

      [">>"] = { norg("core.promo.promote"), "Nest" },
      ["<<"] = { norg("core.promo.demote"),  "Unnest" },

      --["<CR>"] = { norg("core.esupports.hop.hop-link"), "Hop to link" },
      gd       = { norg("core.esupports.hop.hop-link"), "Hop to link" },
    },
    { mode = { "n" }, buffer = bufno }
  )

  wk.register(
    {
      --[">>"] = { all("core.promo.promote_range"), "Nest" },   -- Doesn't work?
      --["<<"] = { all("core.promo.demote_range"),  "Unnest" }, -- Doesn't work?
    },
    { mode = { "v" }, buffer = bufno }
  )
end

return M
