return {

	{ -- kanagawa settings
		"rebelot/kanagawa.nvim",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				undercurl = true,
				transparent = true,
				theme = "dragon",
				-- colors = {
				-- 	palette = {},
				-- 	theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				-- },
				-- overrides = function(colors)
				-- 	return {}
				-- end,
				background = {
					dark = "dragon", -- Use the wave variant for dark mode
					-- light = "lotus",
				},
			})
			-- Apply the colorscheme
			vim.cmd("colorscheme kanagawa")
		end,
	},
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- Useful plugin to show pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter", -- Sets the loading event to 'VimEnter'
		opts = {
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document existing key chains
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	{ -- render for md in nvim
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},

	{ -- devdocs
		"luckasRanarison/nvim-devdocs",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("nvim-devdocs").setup({})
			vim.keymap.set(
				"n",
				"<leader>nd",
				"<cmd>DevdocsOpen<CR>",
				{ noremap = true, desc = "open dev-docs", silent = true }
			)
			vim.keymap.set(
				"n",
				"<leader>nD",
				"<cmd>DevdocsOpenCurrentFloat<CR>",
				{ noremap = true, desc = "Dev-docs for current in float window", silent = true }
			)
		end,
		opts = {},
	},

	{ -- Docstring generator
		"danymat/neogen",
		config = true,
		vim.api.nvim_set_keymap(
			"n",
			"<leader>nf",
			":lua require('neogen').generate()<CR>",
			{ noremap = true, silent = true }
		),
	},

	{ -- For undotree
		"mbbill/undotree",
		config = function()
			-- Key mapping to toggle UndoTree
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })
		end,
	},
}
