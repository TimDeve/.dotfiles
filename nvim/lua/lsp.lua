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

local function on_lsp_attach(client, bufno)
  for type, icon in pairs(utils.diag_signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  local keybinds = {
   ["<leader>"] = {
     l = {
       name = "LSP",
       R = { "<Cmd>LspRestart<CR>",       "Restart LSP" },
       a = { vim.lsp.buf.code_action,     "Code Actions" },
       b = { vim.lsp.buf.references,      "Find references" },
       c = { vim.lsp.codelens.run,        "Code lens" },
       d = { vim.lsp.buf.definition,      "Go to definition" },
       f = { vim.lsp.buf.format,          "Format" },
       h = { vim.lsp.buf.hover,           "Hover" },
       i = { vim.lsp.buf.implementation,  "Go to implementation" },
       r = { vim.lsp.buf.rename,          "Rename" },
       s = { vim.lsp.buf.document_symbol, "Document symbol" },
       t = { vim.lsp.buf.type_definition, "Go to type definition" },
     },
   },
  }

  if client.name == "gopls" then
    local function format_and_organize()
        vim.lsp.buf.format()
        utils.trigger_code_action("Organize Imports")
    end
    keybinds["<leader>lf"] = { format_and_organize, "Format and Organize" }
  end

  wk.register(keybinds)

  autocmd("BufWritePre", {"*.rs", "*.go", "BUILD"}, function() vim.lsp.buf.format() end)

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

  vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references

  autocmd({"CursorHold", "CursorHoldI"}, "<buffer>", function() vim.lsp.buf.document_highlight() end)
  autocmd("CursorMoved", "<buffer>", function() vim.lsp.buf.clear_references() end)

  autocmd({"BufEnter","CursorHold","InsertLeave"}, "<buffer>", function() vim.lsp.codelens.refresh() end)

  local last_lsp_messages = ""
  autocmd("User", "LspProgressUpdate", function()
    local messages = vim.lsp.util.get_progress_messages()
    local str_messages = vim.inspect(messages)

    if last_lsp_messages ~= str_messages then
      last_lsp_messages = str_messages
      for _, payload in ipairs(messages) do
        local title = type(payload.title) == "string" and payload.title or ""
        local message = type(payload.message) == "string" and ": " .. payload.message or ""
        print("[" .. payload.name .. "] " .. title .. message)
      end
    end
  end)
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
    servers_options.gopls.settings = {
       gopls = {
         directoryFilters = {"-plz-out"}
       }
    }
  else
    lsp_config.hls = {}
  end

  setup_servers(shared_options, servers_options)

  rust_tools.setup({ server = { on_attach = on_lsp_attach }})
end

return M
