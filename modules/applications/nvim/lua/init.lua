vim.cmd('packadd nvim-lspconfig')
vim.cmd('packadd completion-nvim')

local lspconfig = require('lspconfig')

lspconfig.pylsp.setup{
  settings = {
    pycodestyle = {
      enabled = false;
    }
  }
}
lspconfig.bashls.setup{}
lspconfig.vimls.setup{}
lspconfig.ccls.setup{}
lspconfig.texlab.setup{}
lspconfig.gopls.setup{}

vim.g.nvim_tree_width = 50  -- 30 by default
vim.g.nvim_tree_follow = true  -- false by default, this option allows the cursor to be updated when entering a buffer
vim.g.nvim_tree_auto_close = true  -- false by default, closes the tree when it's the last window
vim.g.nvim_tree_auto_open = true  -- false by default, opens the tree when typing `vim $DIR` or `vim`
