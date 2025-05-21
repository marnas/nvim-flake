local servers = {
	lua_ls = {
		Lua = {
			formatters = {
				ignoreComments = true,
			},
			signatureHelp = { enabled = true },
			diagnostics = {
				disable = { 'missing-fields' },
				globals = { 'vim' },
			},
		},
		telemetry = { enabled = false },
		filetypes = { 'lua' },
	},

	nixd = {
		nixd = {
			nixpkgs = {
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

	helm_ls = {},

	-- yamlls = {
	-- 	yaml = {
	-- 		schemas = { kubernetes = "*.yaml" },
	-- 	},
	-- },

	gopls = {},
	jsonls = {
		cmd = { 'vscode-json-language-server', '--stdio' },
	},

	terraformls = {},
	tflint = {},

	rust_analyzer = {
		imports = {
			granularity = {
				group = "module",
			},
			prefix = "self",
		},
		cargo = {
			buildScripts = {
				enable = true,
			},
		},
		procMacro = {
			enable = true
		},
	}
}

-- servers.clangd = {},
-- servers.pyright = {},
-- servers.tsserver = {},
-- servers.html = { filetypes = { 'html', 'twig', 'hbs'} },

for server_name, cfg in pairs(servers) do
	require('lspconfig')[server_name].setup({
		-- capabilities = require('blink-cmp').get_lsp_capabilities(),
		capabilities = require('plugins.lsp-on_attach').get_capabilities(),
		on_attach = require('plugins.lsp-on_attach').on_attach,
		settings = cfg,
		filetypes = (cfg or {}).filetypes,
		cmd = (cfg or {}).cmd,
		root_pattern = (cfg or {}).root_pattern,
	})
end

vim.lsp.set_log_level("off")
