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
          -- Your existing file icons
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

      local statusline = require 'mini.statusline'
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl =
              MiniStatusline.section_mode { trunc_width = 120 }
            local git = MiniStatusline.section_git { trunc_width = 40 }
            local diff = MiniStatusline.section_diff { trunc_width = 75 }
            local diagnostics =
              MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
            local filename =
              MiniStatusline.section_filename { trunc_width = 140 }
            local location =
              MiniStatusline.section_location { trunc_width = 75 }
            local search =
              MiniStatusline.section_searchcount { trunc_width = 75 }

            local dap_status = ''
            if package.loaded['dap'] and require('dap').status() ~= '' then
              dap_status = '  ' .. require('dap').status()
            end

            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              {
                hl = 'MiniStatuslineDevinfo',
                strings = { git, diff, diagnostics, lsp },
              },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStarterItemPrefix', strings = { dap_status } },
              { hl = mode_hl, strings = { search, location } },
            }
          end,
        },
      }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
