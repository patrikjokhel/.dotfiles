vim.keymap.set('n', '<leader>tc', '<cmd>SupermavenToggle<CR>', { desc = '[T]oggle AI [C]ompletion' })

return {
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {
        keymaps = {
          accept_suggestion = '<C-[>',
          clear_suggestion = '<C-]>',
        },
      }
    end,
  },
}
