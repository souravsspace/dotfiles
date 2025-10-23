return {
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'nixfmt' },
        go = { 'gofumpt', 'goimports', 'golines' },
      },
    },
  },
}
