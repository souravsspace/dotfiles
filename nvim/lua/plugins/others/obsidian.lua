return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = { 'markdown' },
    event = {
      'BufReadPre '
        .. vim.fn.expand '~'
        .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/savory/*.md',
      'BufNewFile '
        .. vim.fn.expand '~'
        .. '/Library/Mobile Documents/iCloud~md~obsidian/Documents/savory/*.md',
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      -- Point this to your vault on iCloud Drive:
      dir = vim.fn.expand '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/savory',
      workspaces = {
        {
          name = 'savory',
          path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/savory',
        },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      mappings = {
        -- let gf fall back to Obsidian link opener
        ['gf'] = function()
          return require('obsidian').util.gf_passthrough()
        end,
      },
      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      note_id_func = function(title)
        local suffix = ''
        if title then
          suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. '-' .. suffix
      end,
    },
    config = function(_, opts)
      require('obsidian').setup(opts)
      -- Set up keymaps when editing markdown
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local map_opts = { buffer = buf, silent = true }
          vim.keymap.set('n', '<leader>oo', '<cmd>ObsidianOpen<CR>', map_opts)
          vim.keymap.set('n', '<leader>on', '<cmd>ObsidianNew<CR>', map_opts)
          vim.keymap.set('n', '<leader>os', '<cmd>ObsidianSearch<CR>', map_opts)
          vim.keymap.set(
            'n',
            '<leader>ob',
            '<cmd>ObsidianBacklinks<CR>',
            map_opts
          )
          vim.keymap.set(
            'n',
            '<leader>ot',
            '<cmd>ObsidianTemplate<CR>',
            map_opts
          )
        end,
      })
    end,
  },
}
