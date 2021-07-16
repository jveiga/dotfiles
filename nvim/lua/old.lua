vim.cmd [[packadd vim-packager]]
require('packager').setup(function(packager)
	packager.add('itchyny/landscape.vim')
	packager.add('neovim/nvim-lspconfig')
	packager.add('nvim-lua/completion-nvim')
	packager.add('nvim-lua/lsp_extensions.nvim')
	packager.add('phaazon/hop.nvim')	
	packager.add('tpope/vim-commentary')
	packager.add('nvim-lua/popup.nvim')
	packager.add('nvim-lua/plenary.nvim')
	packager.add('nvim-telescope/telescope.nvim')
	packager.add('nvim-telescope/telescope.nvim')
end)

vim.g.colors_name = 'landscape'

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	      virtual_text = true,
    signs = true,
    update_in_insert = true,
    -- { "underline", "severity_sort", "virtual_text", "signs", "update_in_insert" }

  }
)

function goimports(timeout_ms)
	local context = { source = { organizeImports = true } }
	vim.validate { context = { context, "t", true } }

	local params = vim.lsp.util.make_range_params()
	params.context = context

	-- See the implementation of the textDocument/codeAction callback
	-- (lua/vim/lsp/handler.lua) for how to do this properly.
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
	if not result or next(result) == nil then return end
	local actions = result[1].result
	if not actions then return end
	local action = actions[1]

	-- textDocument/codeAction can return either Command[] or CodeAction[]. If it
	-- is a CodeAction, it can have either an edit, a command or both. Edits
	-- should be executed first.
	if action.edit or type(action.command) == "table" then
		if action.edit then
			vim.lsp.util.apply_workspace_edit(action.edit)
		end
		if type(action.command) == "table" then
			vim.lsp.buf.execute_command(action.command)
		end
	else
		vim.lsp.buf.execute_command(action)
	end
end

-- autocmd BufWritePre *.go lua goimports(1000)
vim.cmd [[autocmd BufWritePre *.go lua goimports(1000)]]
-- vim.cmd [[autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()]]
vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.formatting()]]


local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({ 
	on_attach=on_attach ,
	settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

nvim_lsp.gopls.setup {
	cmd = {"gopls", "serve"},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}

vim.api.nvim_set_keymap('n', '\\$', "<cmd>lua require'hop'.hint_words()<cr>", {})
vim.opt.number=true


local nvim_lsp = require'lspconfig'

local on_attach = function(client)
    require'completion'.on_attach(client)
end

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})

require'lspconfig'.gopls.setup{
	on_attach = on_attach,
	-- capabilities = capabilities,
	cmd = {"gopls", "serve"},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}

vim.opt.completeopt='menuone,noinsert,noselect'
vim.opt.shortmess='filnxtToOFc'
