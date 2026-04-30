return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql', 'plsql', 'sqlite', 'redis' },
        lazy = true,
      },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  -- NOTE: dadbod completion for nvim-cmp is configured in cmp.lua via
  -- cmp.setup.filetype for sql filetypes. Do NOT load blink.cmp here;
  -- it is a competing completion engine that breaks nvim-cmp in Rust.

}
