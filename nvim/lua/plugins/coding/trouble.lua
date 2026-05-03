return {
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = 'Trouble',
    keys = {
      {
        '<leader>cD',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>cd',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cp',
        function()
          vim.diagnostic.open_float(nil, {
            scope = 'cursor',
            border = 'rounded',
            source = 'if_many',
          })
        end,
        desc = 'Diagnostic Popup',
      },
      {
        '<leader>cc',
        function()
          local diags = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
          if #diags == 0 then
            vim.notify('No diagnostics on this line', vim.log.levels.INFO)
            return
          end
          local msg = {}
          for _, d in ipairs(diags) do
            table.insert(msg, d.message)
          end
          vim.fn.setreg('+', table.concat(msg, '\n'))
          vim.notify('Copied diagnostic text', vim.log.levels.INFO)
        end,
        desc = 'Copy Diagnostic',
      },
    },
  },
}
