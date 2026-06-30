-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --

  require 'plugins.blink-cmp',
  require 'plugins.conform-nvim',
  require 'plugins.gitsigns',
  require 'plugins.guess-indent',
  -- require 'plugins.indent_line',
  require 'plugins.lazydev-nvim',
  -- require 'plugins.lint',
  require 'plugins.mini',
  require 'plugins.nvim-autopairs',
  require 'plugins.nvim-early-retirement',
  require 'plugins.nvim-lspconfig',
  require 'plugins.nvim-treesitter',
  require 'plugins.nvim-treesitter-context',
  require 'plugins.nvim-ts-autotag',
  require 'plugins.oil',
  require 'plugins.super-maven',
  require 'plugins.tailwind-sorter',
  require 'plugins.telescope-nvim',
  require 'plugins.todo-comments',
  require 'plugins.vim-fugitive',
  require 'plugins.which-key',

  -- import everything under custom/plugins
  { import = 'custom' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2
