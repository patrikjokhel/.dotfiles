return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    main = 'nvim-treesitter', -- Sets main module to use for opts
    lazy = false,
    dependencies = { 'neovim-treesitter/treesitter-parser-registry' },
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      -- Autoinstall languages that are not installed
      auto_install = true,
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          -- Enable treesitter highlighting and disable regex syntax
          pcall(vim.treesitter.start)
          -- Enable treesitter-based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
    config = function(_, opts)
      require('nvim-treesitter.config').setup(opts)

      vim.schedule(function()
        local parsers = {
          'bash',
          'c',
          'diff',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
          'git_config',
          'git_rebase',
          'gitcommit',
          'gitattributes',
          'gitignore',
          'typescript',
          'tsx',
          'javascript',
          'html',
          'css',
          'json',
          'go',
          'sql',
        }

        local already_installed = require('nvim-treesitter.config').get_installed()
        local to_install = vim
          .iter(parsers)
          :filter(function(p)
            return not vim.tbl_contains(already_installed, p)
          end)
          :totable()

        local function ensure_queries(lang)
          local query_path = vim.fn.stdpath 'config' .. '/queries/' .. lang .. '/highlights.scm'
          if vim.fn.filereadable(query_path) == 1 then
            return
          end

          vim.fn.mkdir(vim.fn.stdpath 'config' .. '/queries/' .. lang, 'p')
          local url = 'https://raw.githubusercontent.com/nvim-treesitter/nvim-treesitter/master/queries/' .. lang .. '/highlights.scm'
          vim.fn.system { 'curl', '-fsSo', query_path, url }

          if vim.v.shell_error ~= 0 then
            vim.notify('nvim-treesitter: failed to fetch queries for ' .. lang, vim.log.levels.WARN)
          else
            vim.notify('nvim-treesitter: fetched queries for ' .. lang, vim.log.levels.INFO)
          end
        end
        -- vim.notify('Already installed: ' .. vim.inspect(already_installed))
        -- vim.notify('Installing parsers: ' .. vim.inspect(to_install))
        if #to_install > 0 then
          require('nvim-treesitter').install(to_install, {
            callback = function(lang)
              ensure_queries(lang)
            end,
          })
        end
      end)
    end,
  },
}
