return {
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    enabled = true, -- Make sure it's enabled
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { 'string' },
      skip_unbalanced = true,
      markdown = true,
    },
  },
}
