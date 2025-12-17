local servers = {
	lua_ls = {
		filetypes = { 'lua' },
		settings = {
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
		},
	},

	nixd = {
		filetypes = { 'nix' },
		settings = {
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
		}
	},

	helm_ls = {
		filetypes = { 'helm' },
	},

	yamlls = {
		filetypes = { 'yaml', 'yaml.docker-compose' },
		settings = {
			yaml = {
				schemaStore = {
					enable = true,
					url = "https://www.schemastore.org/api/json/catalog.json",
				},
				-- Auto-generated schemas from datreeio/CRDs-catalog
				schemas = require('utils.yaml-catalog').get_schemas(),
				validate = true,
				completion = true,
			},
		},
	},

	gopls = {
		filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
	},

	jsonls = {
		filetypes = { 'json', 'jsonc' },
		cmd = { 'vscode-json-language-server', '--stdio' },
	},

	terraformls = {
		filetypes = { 'terraform', 'tf' },
	},

	tflint = {
		filetypes = { 'terraform' },
	},

	rust_analyzer = {
		filetypes = { 'rust' },
		settings = {
			['rust-analyzer'] = {
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
	}
}

-- servers.clangd = {},
-- servers.pyright = {},
-- servers.tsserver = {},
-- servers.html = { filetypes = { 'html', 'twig', 'hbs'} },

for server_name, cfg in pairs(servers) do
	vim.lsp.config(server_name, {
		capabilities = require('blink-cmp').get_lsp_capabilities(),
		on_attach = require('plugins.lsp-on_attach').on_attach,
		settings = cfg.settings or {},
		filetypes = cfg.filetypes,
		cmd = cfg.cmd,
		root_dir = cfg.root_dir,
	})
	vim.lsp.enable(server_name)
end

vim.lsp.set_log_level("off")

-- Setup YAML schema auto-detection for CRDs
require('utils.yaml-schema-autodetect')
