-- Disable command line
vim.opt.cmdheight = 0

-- Make line numbers default
vim.opt.number = true

-- Relative numbers
vim.opt.relativenumber = true

-- Disable wrap
vim.wo.wrap = false

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = false

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

local opts = { noremap = true, silent = true }

-- jj, jk to exit insert mode
vim.keymap.set('i', 'jj', '<Esc>', opts)
vim.keymap.set('i', 'jk', '<Esc>', opts)

-- cd, cu to zz mapping
vim.keymap.set('n', 'cd', 'zz', opts)
vim.keymap.set('n', 'cu', 'zz', opts)

-- Toggle word wrap with 'tt' in Normal mode
vim.keymap.set('n', 'mm', '<cmd>set wrap!<CR>', opts)

-- Normal mode
vim.keymap.set('n', '<Up>', '<Nop>', opts)
vim.keymap.set('n', '<Down>', '<Nop>', opts)
vim.keymap.set('n', '<Left>', '<Nop>', opts)
vim.keymap.set('n', '<Right>', '<Nop>', opts)

-- Insert mode
vim.keymap.set('i', '<Up>', '<Nop>', opts)
vim.keymap.set('i', '<Down>', '<Nop>', opts)
vim.keymap.set('i', '<Left>', '<Nop>', opts)
vim.keymap.set('i', '<Right>', '<Nop>', opts)

-- Visual mode
vim.keymap.set('v', '<Up>', '<Nop>', opts)
vim.keymap.set('v', '<Down>', '<Nop>', opts)
vim.keymap.set('v', '<Left>', '<Nop>', opts)
vim.keymap.set('v', '<Right>', '<Nop>', opts)
