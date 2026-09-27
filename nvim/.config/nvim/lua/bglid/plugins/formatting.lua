return {
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style.
				-- local disable_filetypes = { c = true, cpp = true }
				local disable_filetypes = { c = false, cpp = false }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				rust = { "rustfmt" },
				ocaml = { "ocamlformat" },
				menhir = {},
			},
			formatters = {
				ocamlformat = {
					prepend_args = {
						"--if-then-else",
						"vertical",
						"--break-cases",
						"fit-or-vertical",
						"--type-decl",
						"sparse",
					},
				},
			},
		},
	},

	{ -- LINTING!
		"mfussenegger/nvim-lint",
		-- event = "BufWritePost",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				sh = {
					"shellcheck",
				},
				cpp = {
					"cpplint",
				},
				c = {
					"cpplint",
				},
				-- makefile = {
				-- 	"checkmake",
				-- },
			}
			-- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				pattern = { "*.py", "*.c", "*.cc", "*.cpp", "*.h", "*.sh" },
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
