-- Auto-detect and apply CRD schemas when yamlls attaches
local catalog = require('utils.yaml-catalog')

-- Cache to avoid re-detecting on every event
local schema_cache = {}

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or client.name ~= "yamlls" then
			return
		end

		local bufnr = args.buf
		local filename = vim.api.nvim_buf_get_name(bufnr)

		-- Only process yaml files
		if not filename:match("%.ya?ml$") then
			return
		end

		-- Check if already processed
		if schema_cache[filename] then
			return
		end

		local api_version, kind = catalog.get_resource_type(bufnr)

		if not api_version or not kind then
			return -- Can't determine resource type
		end

		local schema_url
		if catalog.is_crd_group(api_version) then
			-- CRD from our supported groups
			local group = api_version:match("^([^/]+)")
			local version = api_version:match("/(.+)$")
			schema_url = string.format(
				"https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/%s/%s_%s.json",
				group,
				kind:lower(),
				version
			)
		else
			-- Core Kubernetes resource - use kubernetes schema
			schema_url = "kubernetes"
		end

		-- Directly modify client settings (yamlls needs this)
		if not client.config.settings.yaml then
			client.config.settings.yaml = {}
		end
		if not client.config.settings.yaml.schemas then
			client.config.settings.yaml.schemas = {}
		end
		client.config.settings.yaml.schemas[schema_url] = filename

		-- Notify yamlls of config change
		client.notify("workspace/didChangeConfiguration", {
			settings = client.config.settings
		})

		-- Cache to avoid re-processing
		schema_cache[filename] = schema_url
	end,
})
