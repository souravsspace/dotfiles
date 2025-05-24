return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = { 'markdown' },
    event = {},
    cmd = {
      'ObsidianOpen',
      'ObsidianNew',
      'ObsidianSearch',
      'ObsidianBacklinks',
      'ObsidianTemplate',
      'ObsidianFollowLink',
      'ObsidianLinkNew',
    },
    keys = {
      { '<leader>oo', '<cmd>ObsidianOpen<CR>' },
      { '<leader>on', '<cmd>ObsidianNew<CR>' },
      { '<leader>os', '<cmd>ObsidianSearch<CR>' },
      { '<leader>ob', '<cmd>ObsidianBacklinks<CR>' },
      { '<leader>ot', '<cmd>ObsidianTemplate<CR>' },
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      dir = vim.fn.expand '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/savory',
      workspaces = {
        {
          name = 'savory',
          path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/savory',
        },
      },
      notes_subdir = 'notes',
      daily_notes = {
        folder = 'notes/dailies',
        date_format = '%Y-%m-%d',
        alias_format = '%B %-d, %Y',
        default_tags = { 'daily-notes' },
        template = nil,
      },
      log_level = vim.log.levels.INFO,
      completion = { nvim_cmp = true, min_chars = 2 },
      mappings = {
        ['gf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { expr = true, buffer = true },
        },
        ['<leader>ch'] = {
          action = function()
            return require('obsidian').util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        ['<cr>'] = {
          action = function()
            return require('obsidian').util.smart_action()
          end,
          opts = { expr = true, buffer = true },
        },
      },
      new_notes_location = 'notes_subdir',
      note_id_func = function(title)
        local suffix = title
            and title:gsub('%s+', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
          or string.rep('', 4)
        if not title then
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. '-' .. suffix
      end,
      note_path_func = function(spec)
        return (spec.dir / tostring(spec.id)):with_suffix '.md'
      end,
      wiki_link_func = function(opts)
        return require('obsidian.util').wiki_link_id_prefix(opts)
      end,
      markdown_link_func = function(opts)
        return require('obsidian.util').markdown_link(opts)
      end,
      preferred_link_style = 'wiki',
      disable_frontmatter = false,
      note_frontmatter_func = function(note)
        if note.title then
          note:add_alias(note.title)
        end
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,
      templates = {
        folder = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
        substitutions = {},
      },
      use_advanced_uri = false,
      open_app_foreground = false,
      picker = {
        name = 'telescope.nvim',
        note_mappings = { new = '<C-x>', insert_link = '<C-l>' },
        tag_mappings = { tag_note = '<C-x>', insert_tag = '<C-l>' },
      },
      sort_by = 'modified',
      sort_reversed = true,
      search_max_lines = 1000,
      open_notes_in = 'current',
      attachments = {
        img_folder = 'assets/imgs',
        img_name_func = function()
          return string.format('%s-', os.time())
        end,
        img_text_func = function(client, path)
          local rel = client:vault_relative_path(path) or path
          return string.format('![%s](%s)', rel.name, rel)
        end,
      },
      ui = { enable = true }, -- ensure UI features enabled
    },
    config = function(_, opts)
      -- Set conceallevel BEFORE loading the plugin
      vim.opt.conceallevel = 1
      vim.opt.concealcursor = 'nc'

      require('obsidian').setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'markdown',
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local m = { buffer = buf, silent = true }
          -- vim.keymap.set('n', '<leader>oo', '<cmd>ObsidianOpen<CR>', m)
          -- vim.keymap.set('n', '<leader>on', '<cmd>ObsidianNew<CR>', m)
          -- vim.keymap.set('n', '<leader>os', '<cmd>ObsidianSearch<CR>', m)
          -- vim.keymap.set('n', '<leader>ob', '<cmd>ObsidianBacklinks<CR>', m)
          -- vim.keymap.set('n', '<leader>ot', '<cmd>ObsidianTemplate<CR>', m)
        end,
      })
    end,
  },
}
