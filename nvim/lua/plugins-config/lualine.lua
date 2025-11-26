local lualine_mode = require("lualine.utils.mode")
local utils = require("utils")
local truthy = utils.truthy

local M = {}

-- Adapted from visual-multi source
-- https://github.com/mg979/vim-visual-multi/blob/724bd53adfbaf32e129b001658b45d4c5c29ca1a/autoload/vm/themes.vim#L101-L127
local function visual_multi_status()
  if not vim.b.visual_multi then
    return nil
  end
  local v = vim.b.VM_Selection.Vars
  local vm = vim.fn.VMInfos()
  local single = truthy(v.single_region) and "%#VM_Mono# SINGLE " or ""
  local color = "%#VM_Extend#"
  local mode = nil
  if truthy(v.insert) then
    if truthy(vim.b.VM_Selection.Insert.replace) then
      mode = "V-R"
      color = "%#VM_Mono#"
    else
      mode = "V-I"
      color = "%#VM_Cursor#"
    end
  else
    local mod_map = { n = "V-M", v = "V", V = "V-L", ["<C-v>"] = "V-B" }
    mode = mod_map[vim.api.nvim_get_mode().mode]
    if mode == nil then
      mode = "V-M"
    end
  end

  mode = vim.b.statusline_mode or mode
  local patterns = "['" .. table.concat(vm.patterns, "', '") .. "']"

  return string.format(
    "%s%s %s %s %s%s %s",
    color, mode, "%#VM_Insert#", vm.ratio, single, "%#TabLine#", patterns
  )
end

local function mode()
  local table_sign = ""
  if truthy(vim.b.table_mode_active) then
    table_sign = "☷ "
  end
  return string.format("%s%s", table_sign,  visual_multi_status() or lualine_mode.get_mode())
end

local function is_buffer_pinned()
  local cur_buf = vim.api.nvim_get_current_buf()
  return require("hbac.state").is_pinned(cur_buf) and " ●" or " ○"
end

local function toggle_pinned()
  require("hbac").toggle_pin()
end

local function progress8()
  local eight = os.time() % 8

  if     eight < 1 then return '⡿'
  elseif eight < 2 then return '⣟'
  elseif eight < 3 then return '⣯'
  elseif eight < 4 then return '⣷'
  elseif eight < 5 then return '⣾'
  elseif eight < 6 then return '⣽'
  elseif eight < 7 then return '⣻'
  else                  return '⢿'
  end
end

local function progress6()
  local sixth = os.time() % 6

  if     sixth < 1 then return '⠟'
  elseif sixth < 2 then return '⠯'
  elseif sixth < 3 then return '⠷'
  elseif sixth < 4 then return '⠾'
  elseif sixth < 5 then return '⠽'
  else                  return '⠻'
  end
end

local function progress3()
  local third = os.time() % 3

  if     third < 1 then return ''
  elseif third < 2 then return ''
  else                  return ''
  end
end

local function ollama()
    local status = require("ollama").status()

    if status == "IDLE" then
      return " LLM"
    elseif status == "WORKING" then
      return progress3() .. " LLM"
    end
end

local config = {
  options = {
    icons_enabled = true,
    theme = "gruvbox_dark",
    section_separators = { left = '', right = ''},
    component_separators = { left = '', right = ''},
  },
  extensions = {"neo-tree", "mundo", "fugitive"},
  sections = {
    lualine_a = {{
      mode,
      on_click = utils.cmd_cb "Neotree show toggle",
    }},
    lualine_b = {
      {
        'branch',
        on_click = utils.cmd_cb "Neotree git_status",
        icon = "Y",
      },
      'diff',
    },
    lualine_c = {
      { is_buffer_pinned, on_click = toggle_pinned },
      { 'filename', path = 1 },
    },
    lualine_x = {
      {
        'diagnostics',
        on_click = utils.cmd_cb "TroubleToggle document_diagnostics",
        symbols = {
          error = utils.diag_signs.Error,
          warn  = utils.diag_signs.Warn,
          info  = utils.diag_signs.Info,
          hint  = utils.diag_signs.Hint,
        },
      },
      'encoding',
      {
        'fileformat',
        symbols = {
          unix = 'LF',
          dos = 'CR/LF',
          mac = 'CR',
        },
      },
      -- {
      -- 'lsp_status',
      --   icon = '', -- f013
      --   symbols = {
      --     -- Standard unicode symbols to cycle through for LSP progress:
      --     -- spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
      --     spinner = { '🌘' },
      --     -- Standard unicode symbol for when LSP is done:
      --     done = '✓',
      --     -- Delimiter inserted between LSP names:
      --     separator = ' ',
      --   },
      --   -- List of LSP names to ignore (e.g., `null-ls`):
      --   ignore_lsp = {},
      -- },
      'filetype',
      {
        ollama,
        cond = function()
          return package.loaded["ollama"] and require("ollama").status() ~= nil
        end,
        on_click = utils.cmd_cb "OllamaServeStop",
      }
    },
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
}

function M.setup()
  require('lualine').setup(config)
end

return M
