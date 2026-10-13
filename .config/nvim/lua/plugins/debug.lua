return {
    {
        "mfussenegger/nvim-dap",
        keys = {
          { "<leader>dn",  function() require("dap").step_over() end,                          desc = "Debug: Step over" },
          { "<leader>di",  function() require("dap").step_into() end,                          desc = "Debug: Step into" },
          { "<leader>do",  function() require("dap").step_out() end,                           desc = "Debug: Step out" },
          { "<leader>db",  function() require("dap").toggle_breakpoint() end,                  desc = "Toggle breakpoint" },
          { "<leader>dc",  function() require("dap").continue() end,                           desc = "Continue" },
          { "<leader>dt",  function() require("dap").terminate() require("dapui").close() end, desc = "Terminate" },
        },
        config = function()
          local dap = require("dap")

          local adapter = {
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = {
              command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
              args = { "${port}", "127.0.0.1" },
            },
          }
          dap.adapters["pwa-node"] = adapter
          dap.adapters["node"] = adapter

          -- map "type" in launch.json to filetype of buffer
          local fts = { "typescript", "javascript" }
          local vscode = require("dap.ext.vscode")
          vscode.type_to_filetypes["pwa-node"] = fts
          vscode.type_to_filetypes["node"] = fts

          -- configuration for attach to a custom port
          for _, ft in ipairs(fts) do
            dap.configurations[ft] = dap.configurations[ft] or {}
            table.insert(dap.configurations[ft], {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              port = function()
                local p = tonumber(vim.fn.input("Inspector port: ", "9229"))
                return p or 9229
              end,
              cwd = "${workspaceFolder}",
              sourceMaps = true,
              restart = true,
              skipFiles = { "<node_internals>/**", "**/node_modules/**" },
            })
          end

          vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
          vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

          local dapui = require("dapui")
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "mfussenegger/nvim-dap",
          "nvim-neotest/nvim-nio",
        },
        keys = {
          { "<leader>du", function() require("dapui").toggle() end, desc = "Debug UI toggle" },
          { "<leader>de", function() require("dapui").eval() end,   desc = "Eval expression", mode = { "n", "v" } },
        },
        config = function()
          local dap, dapui = require("dap"), require("dapui")

          dapui.setup({
            layouts = {
              {
                position = "left",
                size = 40,
                elements = {
                  { id = "scopes" },
                },
              },
            },
          })
        end,
      }
}
