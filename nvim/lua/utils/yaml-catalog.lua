-- Auto-detect Kubernetes CRD schemas from buffer content
local M = {}

-- CRD groups we want to support from datreeio/CRDs-catalog
local crd_groups = {
	"cert-manager.io",
	"acme.cert-manager.io",
	"helm.toolkit.fluxcd.io",
	"kustomize.toolkit.fluxcd.io",
	"source.toolkit.fluxcd.io",
	"notification.toolkit.fluxcd.io",
	"image.toolkit.fluxcd.io",
	"gateway.networking.k8s.io",
	"grafana.integreatly.org",
	"longhorn.io",
	"metallb.io",
	"postgresql.cnpg.io",
	"tailscale.com",
	"traefik.io",
	"hub.traefik.io",
}

-- Extract apiVersion and kind from buffer (simple pattern matching)
function M.get_resource_type(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 50, false) -- Check first 50 lines
	local api_version, kind

	for _, line in ipairs(lines) do
		if not api_version and line:match("^apiVersion:%s*(.+)") then
			api_version = line:match("^apiVersion:%s*(.+)")
		end
		if not kind and line:match("^kind:%s*(.+)") then
			kind = line:match("^kind:%s*(.+)")
		end
		if api_version and kind then
			break
		end
	end

	return api_version, kind
end

-- Check if apiVersion is from a CRD group we care about
function M.is_crd_group(api_version)
	if not api_version or not api_version:match("/") then
		return false -- Core k8s resources like "v1" don't have group
	end

	local group = api_version:match("^([^/]+)")
	for _, crd_group in ipairs(crd_groups) do
		if group == crd_group then
			return true
		end
	end
	return false
end

-- Get static schemas for yamlls config
function M.get_schemas()
	-- Don't set kubernetes = "*.yaml" pattern as it rejects CRD kinds
	-- Instead, we handle both CRDs and core k8s resources dynamically
	return {}
end

return M
