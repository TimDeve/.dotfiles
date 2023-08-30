local M = {}

function M.setup()
  require('llm').setup({
    default_prompt = "llamacpp7",
    prompts = require('llm.util').module.autoload('llm_prompts')
  })
end

M.cmd = {"Llm", "LlmSelect", "LlmDelete", "LlmStore", "LlmMulti", "LlmCancel", "LlmShow"}

return M
