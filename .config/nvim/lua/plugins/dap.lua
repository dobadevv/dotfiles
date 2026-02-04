return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"igorlfs/nvim-dap-view",
		"theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
		"leoluz/nvim-dap-go",
        "mxsdev/nvim-dap-vscode-js"
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dapgo = require("dap-go")

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

        dapgo.setup({
            dap_configurations = {}
        })

			--      dap.configurations.go = {
			--          {
			-- 	type = "go",
			-- 	name = "Debug",
			-- 	request = "launch",
			-- 	program = "${file}",
			-- },
			-- {
			-- 	type = "go",
			-- 	name = "Debug Package",
			-- 	request = "launch",
			-- 	program = "${fileDirname}",
			-- },
			-- {
			-- 	type = "go",
			-- 	name = "Attach to Remote",
			-- 	mode = "remote",
			-- 	request = "attach",
			-- 	host = "127.0.0.1",
			-- 	port = function()
			-- 		return tonumber(vim.fn.input("Port: ", "38697"))
			-- 	end,
			-- },
			--      }

        -- Setup js-debug adapter
        dap.adapters['pwa-node'] = {
            type = 'server',
            host = 'localhost',
            port = '${port}',
            executable = {
                command = 'node',
                args = { '/etc/js-debug/src/dapDebugServer.js', '${port}' },
            },
        }

        -- TypeScript/JavaScript configurations
        -- for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        --     dap.configurations[language] = {
        --         {
        --             type = "pwa-node",
        --             request = "launch",
        --             name = "Launch file",
        --             program = "${file}",
        --             cwd = "${workspaceFolder}",
        --         },
        --         {
        --             type = "pwa-node",
        --             request = "attach",
        --             name = "Attach to Remote",
        --             address = "localhost",
        --             port = function()
        --                 return tonumber(vim.fn.input("Port: ", "9229"))
        --             end,
        --             cwd = "${workspaceFolder}",
        --             localRoot = "${workspaceFolder}",
        --             remoteRoot = "${workspaceFolder}",
        --             sourceMaps = true,
        --             skipFiles = { "<node_internals>/**" },
        --         }
        --     }
        -- end

        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
        vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped" })

        dapui.setup()
    end,
}
