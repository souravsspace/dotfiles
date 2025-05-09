-- https://github.com/windwp/nvim-ts-autotag?tab=readme-ov-file
return {
  'windwp/nvim-ts-autotag',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function()
    require('nvim-ts-autotag').setup {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
      filetypes = {
        'astro',
        'html',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'tsx',
      },
    }
  end,
}
