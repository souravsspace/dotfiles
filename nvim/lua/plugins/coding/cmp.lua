return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()

              -- Optional reverse extension for JS React & TS React
              require('luasnip').filetype_extend(
                'javascript',
                { 'javascriptreact', 'html' }
              )
              require('luasnip').filetype_extend(
                'typescript',
                { 'typescriptreact', 'html' }
              )

              -- -- will exclude all javascript & typescript snippets
              -- require('luasnip.loaders.from_vscode').load {
              --   exclude = { 'javascript' },
              -- }
              -- require('luasnip.loaders.from_vscode').load {
              --   exclude = { 'typescript' },
              -- }
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'petertriho/cmp-git',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- Fix the sources configuration
        sources = {
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'git' },
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },

        -- Window configuration to unify completion and documentation
        window = {
          completion = cmp.config.window.bordered({
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
            max_width = 80,
            max_height = 20,
            scrollbar = true,
          }),
          documentation = cmp.config.window.bordered({
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
            max_width = 80,
            max_height = 20,
            scrollbar = true,
          }),
        },

        -- Experimental features for better window management
        experimental = {
          ghost_text = {
            hl_group = 'Comment',
          },
        },

        -- Keep your existing mapping configuration
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<A-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        },

        -- Add formatting configuration
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              copilot = '[Copilot]',
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              buffer = '[Buffer]',
              path = '[Path]',
              git = '[Git]',
            })[entry.source.name]
            return vim_item
          end,
        },

        -- Performance and behavior settings
        performance = {
          debounce = 60,
          throttle = 30,
          fetching_timeout = 500,
          confirm_resolve_timeout = 80,
          async_budget = 1,
          max_view_entries = 200,
        },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
