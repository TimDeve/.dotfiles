local llamacpp = require('llm.providers.llamacpp')

local M = {}

M.llamacpp13 = {
  provider = llamacpp,
  params = {
    model = 'models/CodeLlama-13B-Instruct-GGUF/codellama-13b-instruct.Q8_0.gguf',
    ['n-gpu-layers'] = 32,
    threads = 20,
    ['repeat-penalty'] = 1.2,
    temp = 0.2,
    ['ctx-size'] = 4096,
    ['n-predict'] = -1
  },
  builder = function(input)
    return {
      prompt = llamacpp.llama_2_format({
        messages = {
          input
        }
      })
    }
  end,
  options = {
    path = os.getenv('LLAMACPP_DIR'),
    main_dir = "",
  }
}

M.llamacpp7 = {
  provider = llamacpp,
  params = {
    model = 'models/CodeLlama-7B-Instruct-GGUF/codellama-7b-instruct.Q8_0.gguf',
    ['n-gpu-layers'] = 32,
    threads = 20,
    ['repeat-penalty'] = 1.2,
    temp = 0.2,
    ['ctx-size'] = 4096,
    ['n-predict'] = -1
  },
  builder = function(input)
    return {
      prompt = llamacpp.llama_2_format({
        messages = {
          input
        }
      })
    }
  end,
  options = {
    path = os.getenv('LLAMACPP_DIR'),
    main_dir = "",
  }
}

return M
