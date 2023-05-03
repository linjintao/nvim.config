
local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }
    use {'ojroques/nvim-osc52'}
    use {'mhinz/vim-signify'}
    use {'neovim/nvim-lspconfig'}
    use {'ms-jpq/coq_nvim', run = 'python3 -m coq deps' }
    use {'ms-jpq/coq.artifacts'}
    use {'ms-jpq/coq.thirdparty'}
    use {'preservim/nerdtree'}
    use {'nvim-tree/nvim-web-devicons'}
    use {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'}
    --use {'romgrk/barbar.nvim'}

    --[[
    -- Git
    use {
      "TimUntersberger/neogit",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("config.neogit").setup()
      end,
    }
    ]]--

    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  local on_attach = function(client, bufnr)
    --require('completion').on_attach()

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings
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

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end
  end

  local function init_key_mapping()
    vim.keymap.set('n', '<F3>', ':NERDTreeToggle<CR>', { noremap = true, silent = false })
    local lspconfig = require('lspconfig')

    -- Automatically start coq
    vim.g.coq_settings = { auto_start = 'shut-up' }

    -- Enable some language servers with the additional completion capabilities offered by coq_nvim
    -- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
    lspconfig.clangd.setup(require('coq').lsp_ensure_capabilities({
      on_attach = on_attach,

    }))

    --[[
    local servers = { 'clangd' }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup(require('coq').lsp_ensure_capabilities({ }))
      ]]--
    vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
    vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
    vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)


    require'barbar'.setup({
      icons = {
        -- Configure the base icons on the bufferline.
        -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
        buffer_index = true,
        buffer_number = false,
      }
    })
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = false }

    if vim.fn.has('macunix') then
      -- Goto buffer in position...
      -- mac alt mapping
      -- 1. insert mode
      -- 2. ctrl-v
      -- 3. alt-1, key to map
      map('n', '¡', '<Cmd>BufferGoto 1<CR>', opts)
      map('n', '™', '<Cmd>BufferGoto 2<CR>', opts)
      map('n', '£', '<Cmd>BufferGoto 3<CR>', opts)
      map('n', '¢', '<Cmd>BufferGoto 4<CR>', opts)
      map('n', '∞', '<Cmd>BufferGoto 5<CR>', opts)
      map('n', '§', '<Cmd>BufferGoto 6<CR>', opts)
      map('n', '¶', '<Cmd>BufferGoto 7<CR>', opts)
      map('n', '•', '<Cmd>BufferGoto 8<CR>', opts)
      map('n', 'ª', '<Cmd>BufferGoto 9<CR>', opts)
    else
      map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
      map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
      map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
      map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
      map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
      map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
      map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
      map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
      map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
      --map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
    end
  end

  packer_init()

  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)
  init_key_mapping()
  
end

return M
