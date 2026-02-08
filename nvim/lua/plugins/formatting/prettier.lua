local supported = {
  'css',
  'graphql',
  'handlebars',
  'html',
  'javascript',
  'javascriptreact',
  'json',
  'jsonc',
  'less',
  'markdown',
  'markdown.mdx',
  'scss',
  'svelte',
  'typescript',
  'typescriptreact',
  'vue',
  'yaml',
}

local excluded_filetypes = {
  'dbui',
  'sql',
  'mysql',
  'plsql',
  'sqlite',
}

return {
  {
    'williamboman/mason.nvim',
    opts = { ensure_installed = { 'prettier', 'prettier-plugin-svelte' } },
  },

  -- conform
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], 'prettier')
        table.insert(opts.formatters_by_ft[ft], 'prettierd')
      end

      opts.format_after_save = function(bufnr)
        -- Disable formatting if global or buffer-local variable is set
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        -- Check if the filetype supports `prettier`
        local filetype = vim.bo[bufnr].filetype

        if vim.tbl_contains(supported, filetype) then
          return { formatters = { 'prettier' }, timeout_ms = 2000 }
        end

        -- Exclude certain filetypes from LSP formatting fallback
        if vim.tbl_contains(excluded_filetypes, filetype) then
          return
        end

        -- Fallback to default LSP formatting
        return { lsp_format = 'fallback' }
      end
    end,
  },

  -- none-ls support
  {
    'nvimtools/none-ls.nvim',
    optional = true,
    opts = function(_, opts)
      local nls = require 'null-ls'
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.prettier)
    end,
  },
}
