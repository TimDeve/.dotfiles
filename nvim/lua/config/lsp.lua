local utils = require("utils")
local autocmd = utils.autocmd
local highlight = utils.highlight

local M = {}

local function setup_servers(shared, lsps)
  local lsp_config = require("lspconfig")
  for server, options in pairs(lsps) do
    local new_options = utils.merge(shared, options)
    lsp_config[server].setup(new_options)
  end
end

local attached_lsp = {}
local function on_lsp_attach(client, bufno)
  local capabilities = client.server_capabilities

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

  vim.cmd [[ nnoremap <silent> <buffer> <C-LeftMouse> <LeftMouse>:lua vim.lsp.buf.definition()<CR> ]]
  vim.cmd [[ nnoremap <silent> <buffer> <RightMouse>  <LeftMouse>:lua vim.lsp.buf.definition()<CR> ]]

  if client.name == "gopls" and not utils.IS_WORK_MACHINE then
    local function format_and_organize()
        vim.lsp.buf.format()
        utils.trigger_code_action("Organize Imports")
    end
    keybinds["<leader>"].l.f = { format_and_organize, "Format and Organize" }
    autocmd("BufWritePre", {"*.go"}, format_and_organize)
  end

  require("which-key").register(keybinds, { mode = {"n", "v"}, buffer = bufno})

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

  function fname_width(fn) return function() fn({fname_width = 60}) end end
  vim.lsp.handlers["textDocument/references"]     = fname_width(require("telescope.builtin").lsp_references)
  vim.lsp.handlers["textDocument/implementation"] = fname_width(require("telescope.builtin").lsp_implementations)
  vim.lsp.handlers["textDocument/typeDefinition"] = fname_width(require("telescope.builtin").lsp_type_definitions)
  vim.lsp.handlers["textDocument/documentSymbol"] = fname_width(require("telescope.builtin").lsp_document_symbols)
  vim.lsp.handlers["workspace/symbol"]            = fname_width(require("telescope.builtin").lsp_dynamic_workspace_symbols)

  if capabilities.documentHighlightProvider ~= nil then
    autocmd({"CursorHold", "CursorHoldI"}, "<buffer>", function() vim.lsp.buf.document_highlight() end)
    autocmd({"CursorMoved", "CursorMovedI"}, "<buffer>", function() vim.lsp.buf.clear_references() end)
  end

  if capabilities.codeLensProvider ~= nil then
    autocmd({"BufEnter","CursorHold","InsertLeave"}, "<buffer>", function() vim.lsp.codelens.refresh() end)
  end
end

function M.setup()
  --require("config.nvim-cmp").setup()
  --local capabilities = require('cmp_nvim_lsp').default_capabilities() 
  --capabilities.textDocument.completion.completionItem.snippetSupport = false

  local shared_options = {
    on_attach = on_lsp_attach,
    flags = {},
    --capabilities = capabilities,
  }

  local servers_options = {
    pylsp = {},
    bufls = {},
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

  if utils.IS_WORK_MACHINE then
    servers_options.please = {
      filetypes = {"please"}
    }

    servers_options.gopls.settings = {
       gopls = {
         ["directoryFilters"] = {
           "-" .. vim.fn.getcwd() .. "/plz-out",
           "+" .. vim.fn.getcwd() .. "/plz-out/go",
         },
       }
    }

    servers_options.gopls.root_dir = function(fname)
      local go_mod = vim.fs.find('go.mod', { upward = true, path = vim.fs.dirname(fname) })[1]
      if go_mod then
        return vim.fs.dirname(go_mod)
      end
      local plzconfig = vim.fs.find('.plzconfig', { upward = true, path = vim.fs.dirname(fname) })[1]
      local src = vim.fs.find('src', { upward = true, path = plzconfig })[1]
      if plzconfig and src then
        local plz_out = vim.fs.dirname(plzconfig) .. "/plz-out"
        vim.env.GOPATH = string.format('%s:%s/go:%s/gen/third_party/go:%s/gen', vim.fs.dirname(src), plz_out, plz_out, plz_out)
        vim.env.GO111MODULE = 'off'
      end
      return vim.fn.getcwd()
    end
  else
    servers_options.hls = {}
  end

  setup_servers(shared_options, servers_options)

  require("config.null-ls").setup(on_lsp_attach)
end

function M.setup_rust_tools()
  require("rust-tools").setup({ server = { on_attach = on_lsp_attach }})
end

return M
