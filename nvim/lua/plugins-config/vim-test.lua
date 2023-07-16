local utils = require("utils")

local M = {}

M.cmd = {"TestFile", "TestNearest", "TestLast", "TestFile", "TestVisit"}

function M.setup()
  local preferred_target = {}
  if utils.IS_WORK_MACHINE then
    vim.g["test#go#runner"] = "gotest"
    vim.g["test#custom_transformations"] = {
      plzgotransform = function(cmd)
        local has_go_test = string.find(cmd, "go test")
        if has_go_test == nil then
          return cmd -- No need to transform test that are not go tests
        end

        local filepath = vim.api.nvim_buf_get_name(0)
        local pquery = require('please.query')
        local plz_root = pquery.reporoot(filepath)
        local test_targets = pquery.whatinputs(plz_root, filepath)
        local targets_len = #test_targets
        local test_target

        if targets_len > 1 then
          local saved = preferred_target[filepath]

          if saved ~= nil then
            test_target = saved
          end

          local choice = vim.fn.inputlist(test_targets)
          if choice < 1 or choice > #test_targets then
            return "echo 'No valid targets'"
          end
          test_target = test_targets[choice]
          preferred_target[filepath] = test_target
        elseif targets_len == 0 then
          return "echo 'No target found'"
        else
          test_target = test_targets[1]
        end

        local nice_output = " | go tool test2json | gotestsum -f testname --raw-command -- cat"

        -- If targeting a specific test
        local i, _, target, folder = string.find(cmd, "-run%s(.+)%s(.+)")
        if i ~= nil then
          return "plz --profile=noremote run " .. test_target .. " -- -test.v -test.run " .. target .. nice_output
        end

        -- If targeting a folder
        local i, _, folder = string.find(cmd, "go test%s%./(.+)/...")
        if i ~= nil then
          return "plz --profile=noremote run " .. test_target .. nice_output
        end

        return "echo 'Could not match a test'"
      end
    }
    vim.g["test#transformation"] = "plzgotransform"
  else
    if vim.g.is_in_tmux then
      vim.g["test#strategy"] = "vimux"
    end

    if utils.has_exe('richgo') then
      vim.g["test#go#runner"] = "richgo"
    end
  end
end

return M

