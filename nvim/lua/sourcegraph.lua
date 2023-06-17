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

local function selection()
  local row1 = vim.api.nvim_buf_get_mark(0, "<")[1]
  local row2 = vim.api.nvim_buf_get_mark(0, ">")[1]
  print(row1)
  print(row2)
end

function M.open_location()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local abs_path = vim.fn.expand("%:p")
  local repo_root = vim.fs.find('.git', { upward = true, path = vim.fs.dirname(abs_path) })[1]
  repo_root = vim.fs.dirname(repo_root)
  local starti, endi = abs_path:find(repo_root)
  local relative_path = abs_path:sub(endi+2)
  --local remote_url = vim.fn.system("git config --get remote.origin.url") -- Sourcegraph doesn't know about the actual repo name?
  local remote_url = os.getenv("SRC_CORE_REPO")

  local endpoint = os.getenv("SRC_ENDPOINT")
  local url = endpoint .. "/-/editor?"
  url = url .. "remote_url=" .. url_encode(remote_url)    .. "&"
  url = url .. "branch="     .. url_encode("master")      .. "&"
  url = url .. "file="       .. url_encode(relative_path) .. "&"
  url = url .. "start_row="  .. tostring(row)             .. "&"
  url = url .. "end_row="    .. tostring(row)             .. "&"
  url = url .. "start_col="  .. tostring(col)             .. "&"
  url = url .. "end_col="    .. tostring(col)

  print("Opening: " .. url)
  vim.fn.system("xdg-open '" .. url .. "'")
end

return M
