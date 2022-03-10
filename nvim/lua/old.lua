vim.cmd [[packadd vim-packager]]
require('packager').setup(function(packager)
	packager.add('itchyny/landscape.vim')
	packager.add('neovim/nvim-lspconfig')
	packager.add('nvim-lua/completion-nvim')
	packager.add('nvim-lua/lsp_extensions.nvim')
	packager.add('nvim-lua/plenary.nvim')
	packager.add('nvim-telescope/telescope.nvim')
	packager.add('nvim-treesitter/nvim-treesitter')
	packager.add('phaazon/hop.nvim')
	packager.add('tpope/vim-commentary')
	packager.add('tpope/vim-fugitive')
	packager.add('tpope/vim-rhubarb')
	packager.add('tpope/vim-sensible')
	packager.add('tpope/vim-vinegar')
	packager.add('junegunn/goyo.vim')
	packager.add('rescript-lang/vim-rescript')
	packager.add('gleam-lang/gleam.vim')
	packager.add('godlygeek/tabular')

end)


-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	  virtual_text = true,
	  signs = true,
	  update_in_insert = true,
	  { "underline", "severity_sort", "virtual_text", "signs", "update_in_insert" }
  }
)

-- vim.cmd [[ autocmd BufWritePre *.go lua vim.lsp.buf.formatting() ]]
-- vim.cmd [[ au BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 2000) ]]
vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.formatting()]]

vim.cmd [[autocmd BufWritePre *.go lua goimports(1000)]]


  function goimports(timeoutms)
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


-- autocmd BufWritePre,FileWritePre * :%s/\s\+$//e | %s/\r$//e
-- vim.cmd [[autocmd BufWritePre *.go lua goimports(1000)]]
-- vim.cmd [[autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()]]
-- vim.cmd [[autocmd BufWritePre *.go lua vim.lsp.buf.formatting()]]
--

-- vim.api.nvim_command("au BufWritePre <buffer> lua vim.lsp.buf.formatting()")
local nvim_lsp = require'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


-- function to attach completion when setting up lsp
local on_attach_go = function(client)
    require'completion'.on_attach(client)

    -- helpers
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
    local opts = { noremap=true, silent=true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    -- if client.resolved_capabilities.document_formatting then
    --     buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    -- elseif client.resolved_capabilities.document_range_formatting then
    --     buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    -- end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
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
	on_attach = on_attach,
	cmd = {"gopls", "serve"},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			codelens= {
				gc_details= true,
			},
			staticcheck = true,
		},
	},
}

vim.api.nvim_set_keymap('n', '\\$', "<cmd>lua require'hop'.hint_words()<cr>", {})
vim.api.nvim_set_keymap('n', ',f', "<cmd>Telescope find_files<cr>", {})
vim.api.nvim_set_keymap('n', ',b', "<cmd>Telescope buffers<cr>", {})
vim.api.nvim_set_keymap('n', ',s', "<cmd>Telescope live_grep<cr>", {})
vim.opt.number=true


local nvim_lsp = require'lspconfig'

local on_attach_rust = function(client)
    require'completion'.on_attach(client)
end

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach_rust,
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

-- Go
require'lspconfig'.gopls.setup{
	on_attach = on_attach_go,
	capabilities = capabilities,
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

vim.cmd [[set smartcase]]
vim.cmd [[set ignorecase]]

vim.opt.completeopt='menuone,noinsert,noselect'
vim.opt.shortmess='filnxtToOFc'

vim.cmd [[augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
colo landscape
]]
