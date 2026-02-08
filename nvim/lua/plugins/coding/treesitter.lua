return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'typescript',
        'vim',
        'vimdoc',
        'ninja',
        'rst',
        'tsx',
        'rust',
        'ron',
        'sql',
        'git_config',
        'gitcommit',
        'git_rebase',
        'gitignore',
        'gitattributes',
        'json5',
        'nix',
        'dockerfile',
        'cmake',
        'go',
        'gomod',
        'gowork',
        'gosum',
        'svelte',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      textobjects = {
        -- selection (vaf, vif, etc.)
        select = {
          enable = true,
          lookahead = true, -- jump forward to textobj (like targets.vim)
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = { query = '@class.inner', desc = 'Select inner of class' },
            ['as'] = {
              query = '@local.scope',
              query_group = 'locals',
              desc = 'Select local scope',
            },
            ['ap'] = '@parameter.outer',
            ['ip'] = '@parameter.inner',
          },
          selection_modes = {
            ['@parameter.outer'] = 'v',
            ['@function.outer'] = 'V',
            ['@class.outer'] = '<c-v>',
          },
          include_surrounding_whitespace = true,
        },

        -- swap (swap function params, arguments)
        -- swap = {
        --   enable = true,
        --   swap_next = { ['<leader>a'] = '@parameter.inner' },
        --   swap_previous = { ['<leader>A'] = '@parameter.inner' },
        -- },

        -- move (goto next/prev function/class/etc)
        -- move = {
        --   enable = true,
        --   set_jumps = true, -- record in jumplist
        --   goto_next_start = {
        --     [']m'] = '@function.outer',
        --     [']]'] = { query = '@class.outer', desc = 'Next class start' },
        --     [']o'] = '@loop.*',
        --     [']s'] = {
        --       query = '@local.scope',
        --       query_group = 'locals',
        --       desc = 'Next scope',
        --     },
        --     [']z'] = {
        --       query = '@fold',
        --       query_group = 'folds',
        --       desc = 'Next fold',
        --     },
        --   },
        --   goto_next_end = {
        --     [']M'] = '@function.outer',
        --     [']['] = '@class.outer',
        --   },
        --   goto_previous_start = {
        --     ['[m'] = '@function.outer',
        --     ['[['] = '@class.outer',
        --   },
        --   goto_previous_end = {
        --     ['[M'] = '@function.outer',
        --     ['[]'] = '@class.outer',
        --   },
        --   goto_next = { [']d'] = '@conditional.outer' },
        --   goto_previous = { ['[d'] = '@conditional.outer' },
        -- },

        -- optional LSP interop peek definition
        -- lsp_interop = {
        --   enable = true,
        --   border = 'none',
        --   floating_preview_opts = {},
        --   peek_definition_code = {
        --     ['<leader>uf'] = '@function.outer',
        --     ['<leader>uF'] = '@class.outer',
        --   },
        -- },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
