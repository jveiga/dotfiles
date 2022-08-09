vim.cmd [[packadd vim-packager]]
require('packager').setup(function(packager)
	packager.add('itchyny/landscape.vim')
	packager.add('neovim/nvim-lspconfig')
	packager.add('nvim-lua/completion-nvim')
	packager.add('nvim-lua/lsp_extensions.nvim')
	packager.add('nvim-lua/lsp-status.nvim')
	packager.add('nvim-lua/plenary.nvim')
	-- packager.add('nvim-telescope/telescope.nvim')
	packager.add('nvim-treesitter/nvim-treesitter', {['do'] =  ':TSUpdate'})
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
	packager.add('preservim/vim-markdown')
	packager.add('vmchale/just-vim')
	packager.add('onsails/lspkind.nvim')
	packager.add('simrat39/rust-tools.nvim')
	-- Autocompletion framework
	packager.add('hrsh7th/nvim-cmp')
	-- cmp LSP completion
	packager.add('hrsh7th/cmp-nvim-lsp')
	-- cmp Snippet completion
	packager.add('hrsh7th/cmp-vsnip')
	-- cmp Path completion
	packager.add('hrsh7th/cmp-path')
	packager.add('hrsh7th/cmp-buffer')
end)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- set updatetime=300
vim.cmd [[set updatetime=2000]]


-- Enable type inlay hints
vim.api.nvim_create_autocmd({"CursorHold"}, {
	pattern = "*.rs",
	callback= function() vim.diagnostic.open_float(nil, { focusable = false }) end
})
-- vim.api.nvim_create_autocmd({"CursorMoved","InsertLeave","BufEnter","BufWinEnter","TabEnter","BufWritePost"},{
-- 	pattern = "*.rs",
-- callback = function() require('lsp_extensions').inlay_hints({ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }) end
-- })

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
	  virtual_text = false,
	  signs = true,
	  update_in_insert = true,
  }
)
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
        -- vim.lsp.util.apply_workspace_edit(action.edit)
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

local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach_go = function(client)
    require'completion'.on_attach(client)

    -- helpers
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(0, ...) end
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
vim.cmd [[colo landscape]]
vim.cmd [[hi CursorLine gui=underline cterm=underline]]
vim.cmd [[set cursorline]]

vim.opt.completeopt='menuone,noinsert,noselect'
vim.opt.shortmess='filnxtToOFc'

-- vim.cmd [[augroup CursorLine
--   au!
--   au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
--   au WinLeave * setlocal nocursorline
-- augroup END
-- colo landscape
-- ]]


-- Provide some indication that rust-analyzer is busy!
local lsp_status = require('lsp-status')
lsp_status.register_progress()

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})

local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(0, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(0, ...) end
local opts = { noremap=true, silent=true }
buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

