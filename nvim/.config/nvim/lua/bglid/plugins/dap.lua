return { -- may remove...
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			-- Configure Python adapter for `nvim-dap`
			dap.adapters.python = {
				type = "executable",
				command = "python", -- Adjust if using virtual environments
				args = { "-m", "debugpy.adapter" },
			}

			-- Define Python-specific debugging configurations
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}", -- Launch the current file
					pythonPath = function()
						return vim.fn.input("Path to Python interpreter: ", "python", "file")
					end,
				},
			}
			-- configure C++ adapter for nvim dap
			dap.configurations.cpp = {
				{
					name = "Launch File",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			-- C dap
			dap.configurations.c = dap.configurations.cpp
			-- Rust dap
			-- dap.configurations.rust = {
			-- 	{
			-- 		name = "Launch Rust",
			-- 		type = "codelldb",
			-- 		request = "launch",
			-- 		program = function()
			-- 			-- build first: `cargo build` (or use a task runner)
			-- 			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
			-- 		end,
			-- 		cwd = "${workspaceFolder}",
			-- 		stopOnEntry = false,
			-- 	},
			-- }
		end,
	},
	-- dap ui
	{
		"nvim-neotest/nvim-nio",
	},
	{
		-- virtual text support
		"theHamsta/nvim-dap-virtual-text",
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = "mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup({
				-- symbols that don't require Nerd Fonts:
				controls = {
					icons = {
						disconnect = "X", -- represents a disconnect action
						pause = "||", -- shows pause (two vertical bars)
						play = ">", -- indicates play/start
						run_last = "↻", -- a clockwise arrow for rerunning the last command
						step_back = "<-", -- for stepping back
						step_into = "↓", -- for stepping into the next block
						step_out = "↑", -- for stepping out of the current block
						step_over = "→", -- for stepping over
						terminate = "■", -- indicates termination
					},
				},
			})
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enable_commands = true,
				commented = true, -- Show virtual_text alongside comment
			})
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
			-- Setting symbols
			vim.fn.sign_define("DapBreakpoint", {
				text = "⊙",
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapBreakpointRejected", {
				text = "❌", -- or "❌"
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})

			vim.fn.sign_define("DapStopped", {
				text = "→", -- or "→"
				texthl = "DiagnosticSignWarn",
				linehl = "Visual",
				numhl = "DiagnosticSignWarn",
			})
			-- setting keymaps
			vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "Toggle Breakpoint" })
			-- to run debugger
			vim.keymap.set("n", "<leader>dr", require("dap").continue, { desc = "Start/continue debugging" })
			-- common dap actions
			vim.keymap.set("n", "<Leader>do", require("dap").step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<Leader>di", require("dap").step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<Leader>d0", require("dap").step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<Leader>dq", require("dap").terminate, { desc = "Terminate DAP" })
			vim.keymap.set("n", "<Leader>du", require("dapui").toggle, { desc = "Toggle DAP UI" })
		end,
	},
}
