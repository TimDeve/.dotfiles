local utils = require("utils")
local utils_vim = require("utils.vim")
local augroup = utils_vim.augroup
local highlight = utils_vim.highlight

local M = {}

local function server_cmd(server_name)
  local success, config = pcall(require, 'lspconfig.configs.' .. server_name)
  if success then
    return config.default_config.cmd
  else
    error("Could not find configuration for server: " .. server_name)
  end
end

local function setup_servers(shared, lsps)
  local lsp_config = require("lspconfig")
  for server, options in pairs(lsps) do
    local cmd = options.cmd
    if cmd == nil then
      cmd = server_cmd(server)
    end

    if utils.has_exe(cmd[1]) then
      local new_options = utils.merge(shared, options)
      lsp_config[server].setup(new_options)
    end
  end
end

local function toggle_hints()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local function on_lsp_attach(client, bufno)
  local capabilities = client.server_capabilities

  local function fname_width(fn) return function(opts) fn(utils.merge(opts, {fname_width = 60})) end end
  local keybinds = {
    -- Set these foud up again so it's not overrriden
    { "J", "<Plug>MoveLineDown", desc = "Move line down"},
    { "K", "<Plug>MoveLineUp",   desc = "Move line up"},
    { "J", "<Plug>MoveBlockDown", desc = "Move block down", mode = { "v" }},
    { "K", "<Plug>MoveBlockUp", desc = "Move block up", mode = { "v" }},

    { "<leader>l", desc = "LSP" },
    { "<leader>lR", "<Cmd>LspRestart<CR>",                                                   desc = "Restart LSP" },
    { "<leader>la", vim.lsp.buf.code_action,                                                 desc = "Code Actions" },
    { "<leader>lb", fname_width(require("telescope.builtin").lsp_references),                desc = "Find references" },
    { "<leader>lc", vim.lsp.codelens.run,                                                    desc = "Code lens" },
    { "<leader>ld", vim.lsp.buf.definition,                                                  desc = "Go to definition" },
    { "<leader>lD", M.peek_definition,                                                       desc = "Peek definition" },
    { "<leader>lh", vim.lsp.buf.hover,                                                       desc = "Hover" },
    { "<leader>li", fname_width(require("telescope.builtin").lsp_implementations),           desc = "Go to implementation" },
    { "<leader>lr", vim.lsp.buf.rename,                                                      desc = "Rename" },
    { "<leader>ls", vim.lsp.buf.signature_help,                                              desc = "Show signature" },
    { "<leader>lt", fname_width(require("telescope.builtin").lsp_type_definitions),          desc = "Go to type definition" },
    { "<leader>lT", M.peek_type_definition,                                                  desc = "Peek type definition" },
    { "<leader>ly", fname_width(require("telescope.builtin").lsp_document_symbols),          desc = "Document symbols" },
    { "<leader>lY", fname_width(require("telescope.builtin").lsp_dynamic_workspace_symbols), desc = "Workspace symbols" },
  }

  if client.server_capabilities.inlayHintProvider then
    table.insert(keybinds, {"<leader>lH", toggle_hints, desc = "Toggle hints" })

    vim.lsp.inlay_hint.enable(true)
  end

  vim.cmd [[ nnoremap <silent> <buffer> <C-LeftMouse> <LeftMouse>:lua vim.lsp.buf.definition()<CR> ]]
  vim.cmd [[ nnoremap <silent> <buffer> <RightMouse>  <LeftMouse>:lua vim.lsp.buf.definition()<CR> ]]

  if client.name == "gopls" then
    table.insert(keybinds, {"<leader>lo", function() utils.trigger_code_action("source.organizeImports") end, desc = "Organize imports" })

    if not utils.IS_WORK_MACHINE then
      local function format_and_organize()
          vim.lsp.buf.format()
          utils.trigger_code_action("source.organizeImports")
      end
      table.insert(keybinds, {"<leader>lf", format_and_organize, desc = "Format and Organize" })
      augroup("lsp-go-fmt", "BufWritePre", {"*.go"}, format_and_organize)
    end
  end

  require("which-key").add(utils.merge({ mode = {"n", "v"}, buffer = bufno }, keybinds))

  highlight("LspCodeLens", { fg = "grey" })
  highlight("LspCodeLensSeparator", { fg = "grey" })

  if capabilities.documentHighlightProvider ~= nil then
    augroup("lsp-highlight", {"CursorHold", "CursorHoldI"}, "<buffer>", function() vim.lsp.buf.document_highlight() end)
    augroup("lsp-references", {"CursorMoved", "CursorMovedI"}, "<buffer>", function() vim.lsp.buf.clear_references() end)
  end

  if capabilities.codeLensProvider ~= nil then
    augroup("lsp-codelens", {"BufEnter","CursorHold","InsertLeave"}, "<buffer>", function() vim.lsp.codelens.refresh({ bufnr = 0 }) end)
  end
end

local function ts_root_dir(runtime)
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
    denols = { root_dir = ts_root_dir("deno"), single_file_support = false },
    lua_ls = {
      settings = {
        Lua = {
          ["diagnostics.disable"] = {"different-requires"},
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua', 'init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME }
          }
        }
      },
      filetypes = { "lua" },
      root_markers = { "init.lua", ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" },
    },
    gopls = {
      settings = {
        gopls = {
          hints = {
            -- assignVariableTypes = true,
            -- compositeLiteralFields = true,
            -- parameterNames = true,
            -- rangeVariableTypes = true,
            constantValues = true,
            functionTypeParameters = true,
          }
        }
      }
    },
    clangd = { filetypes = { "c", "cpp" } },
    pylsp = {
      plugins = {
        black = { enabled = true },
        pylsp_mypy = { enabled = true },
      },
      single_file_support = true,
    },
    ts_ls = { root_dir = ts_root_dir("ts"), single_file_support = false },
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = { features = 'all' }
        }
      }
    }
  }

  if utils.IS_WORK_MACHINE then
    servers_options.postgres_lsp = {
      cmd = { "postgrestools", "lsp-proxy", vim.fn.expand("--config-path=$HOME/.config/postgrestools/global.jsonc") }
    }

    servers_options.please = {
      filetypes = {"please"}
    }

    servers_options.gopls.settings.gopls["directoryFilters"] = {
      "-" .. vim.fn.getcwd() .. "/node_modules",
      "-" .. vim.fn.getcwd() .. "/plz-out",
      "+" .. vim.fn.getcwd() .. "/plz-out/go",
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

        -- If at repo root use PLZ_DEFAULT_ROOT folder as lsp root instead
        if src == vim.fn.getcwd() and os.getenv("PLZ_DEFAULT_ROOT") then
          return src .. "/" .. os.getenv("PLZ_DEFAULT_ROOT")
        end
      end
      return vim.fn.getcwd()
    end
  else
    servers_options.hls = {}
  end


  setup_servers(shared_options, servers_options)
end

function M.setup_rust_tools()
  require("rust-tools").setup({
    tools = {
      inlay_hints = {
        auto = false
      }
    },
    server = { on_attach = on_lsp_attach }
  })
end

local function preview_location_callback(_, result, _, _)
  if result == nil or vim.tbl_isempty(result) then
    -- Nothing to peek
    return nil
  end
  if vim.islist(result) then
    result[1].range["end"].line = 9999
    vim.lsp.util.preview_location(result[1], { max_height = 10 })
  else
    result.range["end"].line = 99999
    vim.lsp.util.preview_location(result, { max_height = 10 })
  end
end

function M.peek_definition()
  local params = vim.lsp.util.make_position_params(0, 'utf-8')
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

function M.peek_type_definition()
  local params = vim.lsp.util.make_position_params(0, 'utf-8')
  return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
end

return M
