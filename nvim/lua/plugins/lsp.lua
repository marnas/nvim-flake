local servers = {

	lua_ls = {
		Lua = {
			formatters = {
				ignoreComments = true,
			},
			signatureHelp = { enabled = true },
			diagnostics = {
				globals = { 'nixCats', 'vim' },
				disable = { 'missing-fields' },
			},
		},
		telemetry = { enabled = false },
		filetypes = { 'lua' },
	},

	nixd = {
		nixd = {
			nixpkgs = {
				-- nixd requires some configuration in flake based configs.
				-- luckily, the nixCats plugin is here to pass whatever we need!
				expr = [[import (builtins.getFlake "]] .. [[") { }   ]],
			},
			formatting = {
				command = { "nixfmt" }
			},
			diagnostic = {
				suppress = {
					"sema-escaping-with"
				}
			}
		}
	},

	yamlls = {
		yaml = {
			schemas = { kubernetes = "*.yaml" },
		},
	},

	gopls = {},
	jsonls = {
		-- cmd = { 'vscode-json-languageserver', '--stdio' },
	},

	terraformls = {},
	tflint = {},

}


-- servers.clangd = {},
-- servers.gopls = {},
-- servers.pyright = {},
-- servers.rust_analyzer = {},
-- servers.tsserver = {},
-- servers.html = { filetypes = { 'html', 'twig', 'hbs'} },

-- If you were to comment out this autocommand
-- and instead pass the on attach function directly to
-- nvim-lspconfig, it would do the same thing.
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('nixCats-lsp-attach', { clear = true }),
	callback = function(event)
		require('plugins.lsp-on_attach').on_attach(vim.lsp.get_client_by_id(event.data.client_id), event.buf)
	end
})

for server_name, cfg in pairs(servers) do
	require('lspconfig')[server_name].setup({
		capabilities = require('plugins.lsp-on_attach').get_capabilities(server_name),
		-- this line is interchangeable with the above LspAttach autocommand
		-- on_attach = require('plugins.lsp-on_attach').on_attach,
		settings = cfg,
		filetypes = (cfg or {}).filetypes,
		cmd = (cfg or {}).cmd,
		root_pattern = (cfg or {}).root_pattern,
	})
end
