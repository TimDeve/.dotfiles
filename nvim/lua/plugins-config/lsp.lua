local utils = require("utils")
local augroup = utils.augroup
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

  local keybinds = {
   ["<leader>"] = {
     l = {
       name = "LSP",
       R = { "<Cmd>LspRestart<CR>",        "Restart LSP" },
       a = { vim.lsp.buf.code_action,      "Code Actions" },
       b = { vim.lsp.buf.references,       "Find references" },
       c = { vim.lsp.codelens.run,         "Code lens" },
       d = { vim.lsp.buf.definition,       "Go to definition" },
       D = { M.peek_definition,            "Peek definition" },
       f = { vim.lsp.buf.format,           "Format" },
       h = { vim.lsp.buf.hover,            "Hover" },
       i = { vim.lsp.buf.implementation,   "Go to implementation" },
       r = { vim.lsp.buf.rename,           "Rename" },
       s = { vim.lsp.buf.signature_help,   "Document symbols" },
       t = { vim.lsp.buf.type_definition,  "Go to type definition" },
       T = { M.peek_type_definition,       "Peek type definition" },
       y = { vim.lsp.buf.document_symbol,  "Document symbols" },
       Y = { vim.lsp.buf.workspace_symbol, "Workspace symbols" },
     },
   },
  }

  vim.cmd [[ nnoremap <silent> <buffer> <C-LeftMouse> <LeftMouse>:lua vim.lsp.buf.definition()<CR> ]]
  vim.cmd [[ nnoremap <silent> <buffer> <RightMouse>  <LeftMouse>:lua vim.lsp.buf.definition()<CR> ]]

  if client.name == "gopls" and not utils.IS_WORK_MACHINE then
    local function format_and_organize()
        vim.lsp.buf.format()
        utils.trigger_code_action("source.organizeImports")
    end
    keybinds["<leader>"].l.f = { format_and_organize, "Format and Organize" }
    augroup("lsp-go-fmt", "BufWritePre", {"*.go"}, format_and_organize)
  end

  require("which-key").register(keybinds, { mode = {"n", "v"}, buffer = bufno})

  augroup("lsp-rust-fmt", "BufWritePre", {"*.rs", "BUILD"}, function() vim.lsp.buf.format() end)

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

  function fname_width(fn) return function(opts) fn(utils.merge(opts, {fname_width = 60})) end end
  vim.lsp.handlers["textDocument/references"]     = fname_width(require("telescope.builtin").lsp_references)
  vim.lsp.handlers["textDocument/implementation"] = fname_width(require("telescope.builtin").lsp_implementations)
  vim.lsp.handlers["textDocument/typeDefinition"] = fname_width(require("telescope.builtin").lsp_type_definitions)
  vim.lsp.handlers["textDocument/documentSymbol"] = fname_width(require("telescope.builtin").lsp_document_symbols)
  vim.lsp.handlers["workspace/symbol"]            = fname_width(require("telescope.builtin").lsp_dynamic_workspace_symbols)

  if capabilities.documentHighlightProvider ~= nil then
    augroup("lsp-highlight", {"CursorHold", "CursorHoldI"}, "<buffer>", function() vim.lsp.buf.document_highlight() end)
    augroup("lsp-references", {"CursorMoved", "CursorMovedI"}, "<buffer>", function() vim.lsp.buf.clear_references() end)
  end

  if capabilities.codeLensProvider ~= nil then
    augroup("lsp-codelens", {"BufEnter","CursorHold","InsertLeave"}, "<buffer>", function() vim.lsp.codelens.refresh() end)
  end
end

function ts_root_dir(runtime)
  return function(fname)
    local file_content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    if runtime == "deno" and #file_content > 0 and file_content[1]:match("deno") ~= nil then
      return vim.fs.dirname(fname)
    end

    if runtime == "deno" then
      return require("lspconfig/util").root_pattern("deno.json")(fname)
    elseif runtime == "ts" then
      return require("lspconfig/util").root_pattern("package.json")(fname)
    else
      return nil
    end
  end
end

function M.setup()
  local shared_options = {
    on_attach = on_lsp_attach,
    flags = {},
  }

  local servers_options = {
    bufls = {},
    denols = { root_dir = ts_root_dir("deno"), single_file_support = false },
    gopls = {},
    pylsp = {},
    tsserver = { root_dir = ts_root_dir("ts"), single_file_support = false },
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
end

function M.setup_rust_tools()
  require("rust-tools").setup({ server = { on_attach = on_lsp_attach }})
end

local function preview_location_callback(_, result, method, _)
  if result == nil or vim.tbl_isempty(result) then
    -- Nothing to peek
    return nil
  end
  if vim.tbl_islist(result) then
    result[1].range["end"].line = 9999
    vim.lsp.util.preview_location(result[1], { max_height = 10 })
  else
    result.range["end"].line = 99999
    vim.lsp.util.preview_location(result, { max_height = 10 })
  end
end

function M.peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

function M.peek_type_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
end

return M
