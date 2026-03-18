local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Clear highlights on search when pressing <Esc> in normal mode
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Split windows
keymap.set('n', 'sv', ':vsplit<Return>', opts)
keymap.set('n', 'ss', ':split<Return>', opts)

-- Tabs
keymap.set('n', 'te', ':tabedit', opts)
keymap.set('n', '<tab>', ':tabnext<Return>', opts)
keymap.set('n', '<s-tab>', ':tabprev<Return>', opts)
keymap.set('n', '<leader><tab>d', ':tabclose<Return>', opts)

-- IncRename
vim.keymap.set('n', '<leader>cr', function()
  return ':IncRename ' .. vim.fn.expand '<cword>'
end, { desc = 'LSP Rename', expr = true })

-- Show notifications history
keymap.set('n', '<leader>n', function()
  Snacks.notifier.show_history()
end, { desc = 'Notifications' })

-- Buffers
keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
keymap.set('n', '<leader>bd', function()
  Snacks.bufdelete()
end, { desc = 'Delete Buffer' })
keymap.set('n', '<leader>bo', function()
  Snacks.bufdelete.other()
end, { desc = 'Delete Other Buffers' })
keymap.set(
  'n',
  '<leader>bD',
  '<cmd>:bd<cr>',
  { desc = 'Delete Buffer and Window' }
)

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup(
    'kickstart-highlight-yank',
    { clear = true }
  ),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Better indenting
keymap.set('v', '<', '<gv')
keymap.set('v', '>', '>gv')

-- Show diagnostic error message
keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

-- Copy diagnostic message to clipboard
keymap.set('n', 'gc', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #diagnostics > 0 then
    local messages = {}
    for _, diagnostic in ipairs(diagnostics) do
      table.insert(messages, diagnostic.message)
    end
    local text = table.concat(messages, '\n')
    vim.fn.setreg('+', text)
    vim.notify('Diagnostic copied to clipboard', vim.log.levels.INFO)
  else
    vim.notify('No diagnostic on current line', vim.log.levels.WARN)
  end
end, { desc = 'Copy diagnostic' })
