return {
  'mg979/vim-visual-multi',
  -- load when any buffer is read:
  event = 'BufReadPost',
  -- let LazyVim call `require("vim-visual-multi").setup(opts)` for you:
  opts = {
    -- you can override defaults here; the plugin’s README lists all options :contentReference[oaicite:0]{index=0}
    -- e.g., to disable in certain filetypes:
    -- disabled_filetypes = { "help", "alpha", "dashboard" },
  },
}
