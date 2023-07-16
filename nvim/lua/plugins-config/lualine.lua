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

  mode = vim.v.statusline_mode or mode
  local patterns = "['" .. table.concat(vm.patterns, "', '") .. "']"

  return string.format(
    "%s%s  %s%s %s%s %s",
    color, mode, "%#VM_Insert#", vm.ratio, single, "%#TabLine#", patterns
  )
end

local function mode()
  return visual_multi_status() or lualine_mode.get_mode()
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
    lualine_c = {{ 'filename', path = 1 }},
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
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
}

function M.setup()
  require('lualine').setup(config)
end

return M
