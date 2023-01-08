local cmd = vim.cmd
local lsp_config = require("lspconfig")
local wk = require("which-key")
local utils = require("utils")
local rust_tools = require("rust-tools")
local autocmd = utils.autocmd
local highlight = utils.highlight

local M = {}

local function setup_servers(shared, lsps)
  for server, options in pairs(lsps) do
    local new_options = utils.merge(shared, options)
    lsp_config[server].setup(new_options)
  end
end

local last_lsp_messages = ""
local last_lsp_printed = ""
local function lsp_progress_callback()
    local messages = vim.lsp.util.get_progress_messages()
    local str_messages = vim.inspect(messages)

    if last_lsp_messages ~= str_messages then
      last_lsp_messages = str_messages
      for _, payload in ipairs(messages) do
        local title = type(payload.title) == "string" and payload.title or ""
        local message = type(payload.message) == "string" and ": " .. payload.message or ""
        local full_message = "[" .. payload.name .. "] " .. title .. message
        if full_message ~= last_lsp_printed then
          vim.api.nvim_echo({{full_message, "Comment"}}, true, {})
          last_lsp_printed = full_message
        end
      end
    end
end

local attached_lsp = {}

local function on_lsp_attach(client, bufno)
  if attached_lsp[client.name] ~= nil then
    return -- Exit early if already attached
  end
  attached_lsp[client.name] = true

  local capabilities = client.server_capabilities
  lsp_capbilities = capabilities

  for type, icon in pairs(utils.diag_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local keybinds = {
   ["<leader>"] = {
     l = {
       name = "LSP",
       R = { "<Cmd>LspRestart<CR>",        "Restart LSP" },
       a = { vim.lsp.buf.code_action,      "Code Actions" },
       b = { vim.lsp.buf.references,       "Find references" },
       c = { vim.lsp.codelens.run,         "Code lens" },
       d = { vim.lsp.buf.definition,       "Go to definition" },
       f = { vim.lsp.buf.format,           "Format" },
       h = { vim.lsp.buf.hover,            "Hover" },
       i = { vim.lsp.buf.implementation,   "Go to implementation" },
       r = { vim.lsp.buf.rename,           "Rename" },
       s = { vim.lsp.buf.document_symbol,  "Document symbols" },
       S = { vim.lsp.buf.workspace_symbol, "Workspace symbols" },
       t = { vim.lsp.buf.type_definition,  "Go to type definition" },
     },
   },
  }

  if client.name == "gopls" then
    if utils.IS_WORK_MACHINE then
      -- Don't bind functionality using vim-go
      keybinds["<leader>"].l.i = nil
      keybinds["<leader>"].l.f = nil
      keybinds["<leader>"].l.b = nil
    else
      local function format_and_organize()
          vim.lsp.buf.format()
          utils.trigger_code_action("Organize Imports")
      end
      keybinds["<leader>"].l.f = { format_and_organize, "Format and Organize" }
      autocmd("BufWritePre", {"*.go"}, format_and_organize)
    end
  end

  wk.register(keybinds)

  autocmd("BufWritePre", {"*.rs", "BUILD"}, function() vim.lsp.buf.format() end)

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      signs = { active = utils.diag_signs },
      virtual_text = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    }
  )

  highlight("LspCodeLens", { fg = "grey" })
  highlight("LspCodeLensSeparator", { fg = "grey" })

  vim.lsp.handlers["textDocument/references"]     = require("telescope.builtin").lsp_references
  vim.lsp.handlers["textDocument/implementation"] = require("telescope.builtin").lsp_implementations
  vim.lsp.handlers["textDocument/typeDefinition"] = require("telescope.builtin").lsp_type_definitions
  vim.lsp.handlers["textDocument/documentSymbol"] = require("telescope.builtin").lsp_document_symbols
  vim.lsp.handlers["workspace/symbol"]            = require("telescope.builtin").lsp_dynamic_workspace_symbols

  if capabilities.documentHighlightProvider ~= nil then
    autocmd({"CursorHold", "CursorHoldI"}, "<buffer>", function() vim.lsp.buf.document_highlight() end)
    autocmd("CursorMoved", "<buffer>", function() vim.lsp.buf.clear_references() end)
  end

  if capabilities.codeLensProvider ~= nil then
    autocmd({"BufEnter","CursorHold","InsertLeave"}, "<buffer>", function() vim.lsp.codelens.refresh() end)
  end

  autocmd("User", "LspProgressUpdate", lsp_progress_callback)
end

function M.setup()
  local shared_options = {
    on_attach = on_lsp_attach,
    flags = {},
  }

  local servers_options = {
    pylsp = {},
    tsserver = {},
    gopls = {},
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = { features = 'all' }
        }
      }
    }
  }

  if vim.g.IS_WORK_MACHINE then
    servers_options.please = {
      filetypes = {"please"}
    }
    --servers_options.gopls = nil
    servers_options.gopls.settings = {
       gopls = {
         ["directoryFilters"] = {
           "-" .. vim.fn.getcwd() .. "/plz-out",
           "+" .. vim.fn.getcwd() .. "/plz-out/go",
         },
       }
    }
  else
    lsp_config.hls = {}
  end

  setup_servers(shared_options, servers_options)

  rust_tools.setup({ server = { on_attach = on_lsp_attach }})
end

return M
