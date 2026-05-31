local M = {}
function M.on_attach(client, bufnr)
	if client.config.name == 'yamlls' and vim.bo.filetype == 'helm' then
		vim.lsp.buf_detach_client(bufnr, client.id)
	end

	local nmap = function(keys, func, desc)
		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
	end

	-- 0.11 built-in defaults (no need to map): K=hover, grn=rename, grr=references,
	-- gri=implementation, gO=doc_symbols, gra=code_action, [d/]d=diagnostics
	nmap('gd',         vim.lsp.buf.definition,                                  '[G]oto [D]efinition')
	nmap('gD',         vim.lsp.buf.declaration,                                 '[G]oto [D]eclaration')
	nmap('<leader>D',  vim.lsp.buf.type_definition,                             'Type [D]efinition')
	nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
	-- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

	nmap('<leader>wa', vim.lsp.buf.add_workspace_folder,    '[W]orkspace [A]dd Folder')
	nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
	nmap('<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, '[W]orkspace [L]ist Folders')

	vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
		vim.lsp.buf.format()
	end, { desc = 'Format current buffer with LSP' })

	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
		end,
	})
end

return M
