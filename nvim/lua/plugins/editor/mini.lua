return {
  {
    'echasnovski/mini.nvim',
    specs = {
      { 'nvim-tree/nvim-web-devicons', enabled = false, optional = true },
    },
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,

    config = function()
      require('mini.icons').setup {
        style = 'glyph',
        directory = {
          [''] = { glyph = '', hl = 'MiniIconsBlue' }, -- Default folder
          ['src'] = { glyph = '󰙅', hl = 'MiniIconsCyan' },
          ['node_modules'] = { glyph = '', hl = 'MiniIconsRed' },
          ['.github'] = { glyph = '', hl = 'MiniIconsPurple' },
        },
        file = {
          ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
          ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
          ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
          ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
          ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
          ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
          ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
          ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
          ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
          ['.env'] = { glyph = '󰟋', hl = 'MiniIconsOrange' },
          ['.env.local'] = { glyph = '󰟋', hl = 'MiniIconsYellow' },
          ['.env.example'] = { glyph = '󰟋', hl = 'MiniIconsBlue' },
        },
        extension = {},
        filetype = {},
        lsp = {},
        os = {},

        -- Control which extensions will be considered during "file" resolution
        use_file_extension = function(ext, file)
          return true
        end,
      }

      require('mini.ai').setup { n_lines = 500 }

      require('mini.surround').setup {
        mappings = {
          add = 'gza',
          delete = 'gzd',
          find = 'gzf',
          find_left = 'gzF',
          highlight = 'gzh',
          replace = 'gzr',
          update_n_lines = 'gzn',
        },
      }

      require('mini.move').setup {
        mappings = {
          left = 'H',
          right = 'L',
          down = 'J',
          up = 'K',
          line_left = '',
          line_right = '',
          line_down = '',
          line_up = '',
        },
      }

      -- MiniStatusline removed as requested
    end,
  },
}
