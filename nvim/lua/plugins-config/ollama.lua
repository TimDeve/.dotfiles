local M = {}

M.cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" }

M.keys = {
  {
    "<leader>oo",
    ":<c-u>lua require('ollama').prompt()<cr>",
    desc = "ollama prompt",
    mode = { "n", "v" },
  },

  {
    "<leader>oG",
    ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
    desc = "ollama Generate Code",
    mode = { "n", "v" },
  },
}

M.opts = {
  model = "phi3",
  url = "http://127.0.0.1:11434",
  serve = {
    on_start = false,
    command = "ollama",
    args = { "serve" },
    stop_command = "pkill",
    stop_args = { "-SIGTERM", "ollama" },
  },
  prompts = {}
}

return M
