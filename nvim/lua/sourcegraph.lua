local utils = require("utils")

local M = {}

local function char_to_hex(c)
  return string.format("%%%02X", string.byte(c))
end

local function url_encode(s)
  if s == nil then
    return
  end
  s = s:gsub("\n", "")
  s = s:gsub("([^%w ])", char_to_hex)
  s = s:gsub(" ", "+")
  return s
end

local function query(kvs)
  local kv_pairs = {}
  for key, value in pairs(kvs) do
    local pair =  key .. "=" .. url_encode(tostring(value))
    table.insert(kv_pairs, pair)
  end

  return table.concat(kv_pairs, "&")
end

function M.open_location(range, commitish)
  local start_row, start_col, end_row, end_col, _
  if range then
    _, start_row, start_col = unpack(vim.fn.getpos("'<"))
    _, end_row, end_col = unpack(vim.fn.getpos("'>"))
  else
    _, start_row, start_col = unpack(vim.fn.getpos("."))
    end_row = start_row
    end_col = start_col
  end

  local abs_path = vim.fn.expand("%:p")
  local repo_root = vim.fs.find('.git', { upward = true, path = vim.fs.dirname(abs_path) })[1]
  repo_root = vim.fs.dirname(repo_root)
  local _, endi = abs_path:find(repo_root, 1, true)
  local relative_path = abs_path:sub(endi+2)
  --local remote_url = vim.fn.system("git config --get remote.origin.url") -- Sourcegraph doesn't know about the actual repo name?
  local remote_url = os.getenv("SRC_CORE_REPO")
  local endpoint = os.getenv("SRC_ENDPOINT")

  if commitish == nil then
    local exit_code
    commitish, exit_code = utils.capture_shell("git describe --tags --exact-match")
    if exit_code ~= 0 then
      local upstream_ref = utils.capture_shell('git for-each-ref --format="\\%(upstream)" "$(git symbolic-ref -q HEAD)"')
      _, endi = upstream_ref:find("origin", 1, true)
      if endi == nil then
        upstream_ref = utils.capture_shell('git for-each-ref --format="\\%(upstream)" "'..upstream_ref..'"')
        _, endi = upstream_ref:find("origin", 1, true)
      end
      if endi == nil then
        print("falling back to master...")
        commitish = "master"
      else
        commitish = upstream_ref:sub(endi+2)
      end
    end
  end

  local url = endpoint .. "/-/editor?" .. query {
    remote_url = remote_url,
    branch = commitish,
    file = relative_path,
    start_row = start_row - 1,
    end_row = end_row - 1,
    -- end_col = end_col - 1,
    -- start_col = start_col - 1,
  }

  vim.fn.system("xdg-open '" .. url .. "'")

  if os.getenv("TMUX") ~= nil then
    vim.fn.system("echo '" .. url .. "' | tmux load-buffer -w -")
  end
end

return M
