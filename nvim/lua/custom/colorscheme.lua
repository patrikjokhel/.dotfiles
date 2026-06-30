return {
  -- {
  --   dir = vim.fn.expand '~/Development/projects/cyberpunk.nvim',
  --   enabled = false,
  --   name = 'cyberpunk',
  --   dev = { true },
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'cyberpunk'
  --   end,
  -- },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    enabled = true,
    config = function()
      require('catppuccin').setup {
        auto_integrations = true,
        integrations = {
          treesitter = true,
          nvimtree = true,
        },
        flavour = 'mocha',
        float = {
          transparent = true,
          solid = false,
        },
        highlight_overrides = {
          mocha = function(mocha)
            return {
              Comment = {
                fg = mocha.base,
                bg = mocha.overlay0,
              },
            }
          end,
        },
      }
      vim.cmd.colorscheme 'catppuccin-nvim'
    end,
  },
  -- {
  --   'Lambozhuang/cyberpunk.nvim',
  --   enabled = false,
  --   priority = 1000,
  --   opts = {
  --     transparent = true, -- set to true for transparent background
  --   },
  -- },
}
