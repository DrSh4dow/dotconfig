local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
    return
end

return packer.startup(function(use)
    -- plugin for packer itself
    use 'wbthomason/packer.nvim'

    -- some dependancies
    use 'nvim-lua/plenary.nvim'

    -- tmux & split window navigation
    use 'christoomey/vim-tmux-navigator'

    -- maximizes and restores current window
    use 'szw/vim-maximizer'

    -- vim surround
    use 'tpope/vim-surround'

    -- commenting with gc
    use 'numToStr/Comment.nvim'

    -- file explorer
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
    }

    -- colorscheme
    use 'gruvbox-community/gruvbox'

    if packer_bootstrap then
        require("packer").sync()
    end
end)
