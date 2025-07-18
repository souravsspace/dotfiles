return {
  {
    'mason-org/mason.nvim',
    opts = { ensure_installed = { 'biome' } },
  },
  {
    'stevearc/conform.nvim',
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      local supported = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json', 'jsonc' }
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], 'biome')
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        require_cwd = true,
      }
    end,
  },
  {
    'nvimtools/none-ls.nvim',
    optional = true,
    opts = function(_, opts)
      local nls = require 'null-ls'
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.biome)
    end,
  },
}
