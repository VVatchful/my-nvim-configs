local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	{
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup {}
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup ({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "rust" },

				auto_install = true,

				highlight = {
					enable = true,
				},

				incremenatal_selection = {
					enable = true,
					keymaps = {
						init_selection = "<Leader>ss",
						node_incremental = "<Leader>si",
						scope_incremental = "<Leader>sc",
						node_decremental = "<Leader>sd",

					},
				},

				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							-- You can also use captures from other query groups like `locals.scm`
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},

						selection_modes = {
							['@parameter.outer'] = 'v',         				
							['@function.outer'] = 'V',         				
							['@class.outer'] = '<c-v>',       				},	
							include_surrounding_whitespace = true,
						},
					},
				})
			end,
		},

		{
			"nvim-treesitter/nvim-treesitter-textobjects",
		},

		{
			"luisiacc/gruvbox-baby",
			config = function()
				vim.cmd("colorscheme gruvbox-baby")
			end,
		},
		{
			{
				'VonHeikemen/lsp-zero.nvim',
				branch = 'v3.x',
				lazy = true,
				config = false,
				init = function()
					-- Disable automatic setup, we are doing it manually
					vim.g.lsp_zero_extend_cmp = 0
					vim.g.lsp_zero_extend_lspconfig = 0
				end,
			},
			{
				'williamboman/mason.nvim',
				lazy = false,
				config = true,
			},

			-- Autocompletion
			{
				'hrsh7th/nvim-cmp',
				event = 'InsertEnter',
				dependencies = {
					{'L3MON4D3/LuaSnip'},
				},
				config = function()
					-- Here is where you configure the autocompletion settings.
					local lsp_zero = require('lsp-zero')
					lsp_zero.extend_cmp()

					-- And you can configure cmp even more, if you want to.
					local cmp = require('cmp')
					local cmp_action = lsp_zero.cmp_action()

					cmp.setup({
						formatting = lsp_zero.cmp_format({details = true}),
						mapping = cmp.mapping.preset.insert({
							['<C-Space>'] = cmp.mapping.complete(),
							['<C-u>'] = cmp.mapping.scroll_docs(-4),
							['<C-d>'] = cmp.mapping.scroll_docs(4),
							['<C-f>'] = cmp_action.luasnip_jump_forward(),
							['<C-b>'] = cmp_action.luasnip_jump_backward(),
						}),
						snippet = {
							expand = function(args)
								require('luasnip').lsp_expand(args.body)
							end,
						},
					})
				end
			},

			-- LSP
			{
				'neovim/nvim-lspconfig',
				cmd = {'LspInfo', 'LspInstall', 'LspStart'},
				event = {'BufReadPre', 'BufNewFile'},
				dependencies = {
					{'hrsh7th/cmp-nvim-lsp'},
					{'williamboman/mason-lspconfig.nvim'},
				},
				config = function()
					-- This is where all the LSP shenanigans will live
					local lsp_zero = require('lsp-zero')
					lsp_zero.extend_lspconfig()

					--- if you want to know more about lsp-zero and mason.nvim
					--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
					lsp_zero.on_attach(function(client, bufnr)
						-- see :help lsp-zero-keybindings
						-- to learn the available actions
						lsp_zero.default_keymaps({buffer = bufnr})
					end)

					require('mason-lspconfig').setup({
						ensure_installed = {},
						handlers = {
							-- this first function is the "default handler"
							-- it applies to every language server without a "custom handler"
							function(server_name)
								require('lspconfig')[server_name].setup({})

							end,

							-- this is the "custom handler" for `lua_ls`
							lua_ls = function()
								-- (Optional) Configure lua language server for neovim
								local lua_opts = lsp_zero.nvim_lua_ls()
								require('lspconfig').lua_ls.setup(lua_opts)
							end,
						}
					})
				end
			}
		}
	})

