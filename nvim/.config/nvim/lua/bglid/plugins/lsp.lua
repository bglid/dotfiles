return {
	{ -- Rust super plugin (LSP + inlay hints + DAP glue)
		"mrcjkb/rustaceanvim",
		version = "^5",
		ft = { "rust" },
		init = function()
			-- Configure before the plugin loads
			vim.g.rustaceanvim = {
				server = {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true, allTargets = true },
							check = { command = "clippy", allTargets = true }, -- Linter
							procMacro = { enable = true },
							inlayHints = {
								bindingModeHints = { enable = true },
								typeHints = { enable = true },
								parameterHints = { enable = true },
								closingBraceHints = { enable = true },
							},
						},
					},
					on_attach = function(_, bufnr)
						local map = function(lhs, rhs, desc)
							vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
						end
						map("gd", require("telescope.builtin").lsp_definitions, "LSP: Goto Definition")
						map("gr", require("telescope.builtin").lsp_references, "LSP: References")
						map("K", vim.lsp.buf.hover, "LSP: Hover")
						map("<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
						map("<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
						-- Rust-specific
						map("<leader>rr", function()
							vim.cmd.RustLsp("runnables")
						end, "Rust: Runnables")
						map("<leader>rt", function()
							vim.cmd.RustLsp("testables")
						end, "Rust: Testables")
						map("<leader>re", function()
							vim.cmd.RustLsp("expandMacro")
						end, "Rust: Expand Macro")
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
						end, "Toggle Inlay Hints")
					end,
				},
			}
		end,
	},

	-- Cargo.toml UX (versions, features, upgrade hints)
	{
		"saecki/crates.nvim",
		ft = { "toml" },
		config = function()
			require("crates").setup()
		end,
	},

	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					--
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Rename the variable under your cursor.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					--
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				virtual_text = true,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			local util = require("lspconfig.util")

			local servers = {
				-- c++ lsp:
				clangd = {
					filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
					cmd = {
						"clangd",
						-- "--fallback-style={BasedOnStyle: llvm, DerivePointerAlignment: false, PointerAlignment: Left, ReferenceAlignment: Left}",
						"--fallback-style={"
							.. "BasedOnStyle: LLVM, "
							.. "DerivePointerAlignment: false, "
							.. "PointerAlignment: Right, "
							.. "ReferenceAlignment: Right, "
							.. "SpacesBeforeTrailingComments: 2, "
							.. "}",
						"--function-arg-placeholders=0",
					},
				},
				-- python
				ty = {},
				ruff = {},
				--Bash lsp:
				bashls = {},
				-- OCAML
				ocamllsp = {
					filetypes = {
						"ocaml",
						"ocaml.menhir",
						"ocaml.interface",
						"ocaml.ocamllex",
						"reason",
						"dune",
					},
					root_dir = util.root_pattern("dune-project", "dune-workspace", "*.opam", "esy.json", ".git"),
				},

				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"debugpy", --Python debugger
				"clangd", --cpp lsp
				"clang-format", --cpp formatter
				"codelldb", --cpp, c, and Rust debugger
				"checkmake", --Makefile linter
				"cmakelang", -- cmake linter and formatter
				"cmakelint",
				"rust-analyzer",
				"bash-language-server",
				"bashls",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
