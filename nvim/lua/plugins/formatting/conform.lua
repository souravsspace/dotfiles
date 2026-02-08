return {
  {
    'stevearc/conform.nvim',
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.lua = { 'stylua' }
      opts.formatters_by_ft.nix = { 'nixfmt' }
      opts.formatters_by_ft.javascript = { 'biome', 'biome-organize-imports' }
      opts.formatters_by_ft.javascriptreact = { 'biome', 'biome-organize-imports' }
      opts.formatters_by_ft.typescript = { 'biome', 'biome-organize-imports' }
      opts.formatters_by_ft.typescriptreact = { 'biome', 'biome-organize-imports' }
      opts.formatters_by_ft.svelte = { 'biome' }
      opts.formatters_by_ft.go = { 'gofumpt', 'goimports', 'golines' }
      
      return opts
    end,
  },
}
