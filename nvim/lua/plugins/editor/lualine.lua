return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {
    options = {
      icons_enabled = true,
      theme = 'catppuccin',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = { 'NvimTree' },
    },
    sections = {
      lualine_a = {
        {
          'mode',
          separator = { left = '', right = '' },
          padding = { left = 1, right = 1, top = 1, bottom = 1 },
        },
      },
      lualine_b = {
        {
          'branch',
          separator = { left = '', right = '' },
          padding = { left = 1, right = 1, top = 1, bottom = 1 },
        },
        -- 'diff',
        -- 'diagnostics',
      },
      lualine_c = {
        {
          'filename',
          path = 1,
          padding = { left = 1, right = 1, top = 1, bottom = 1 },
        },
      },
      lualine_x = {},
      lualine_y = {
        {
          'datetime',
          style = '%I:%M %p',
          separator = { left = '', right = '' },
          padding = { left = 1, right = 1, top = 1, bottom = 1 },
        },
      },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          'filename',
          separator = { left = '', right = '' },
          padding = { left = 1, right = 1, top = 1, bottom = 1 },
        },
      },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
  },
}
