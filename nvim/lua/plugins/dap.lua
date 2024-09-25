return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup()

		local debug_py = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
		require("dap-python").setup(debug_py, { include_configs = true, console = "externalTerminal" })

		--  signs
        local sign = vim.fn.sign_define

        sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = ""})
        sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = ""})
        sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = ""})

		-- configurations
		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "FastAPI",
				module = "uvicorn",
				args = {
					"main:app",
					"--host",
					"0.0.0.0",
					"--port",
					"8080",
					-- "--reload"
				},
				pythonPath = 'python',
			},
		}

		-- open and close the ui windows automatically
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({ reset = true })
        require('neo-tree.command')._command('close')
    end
    dap.listeners.before.event_terminated["dapui_config"] = function(e)
        require("astronvim.utils").notify "Terminating Debug session"
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end
	end,
}
