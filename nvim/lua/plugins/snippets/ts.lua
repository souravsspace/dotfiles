return {
  {
    'L3MON4D3/LuaSnip',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local ls = require 'luasnip'
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node

      -- Function to get component name from filename
      local function get_component_name()
        local filename = vim.fn.expand '%:t:r' -- Get filename without extension
        -- Capitalize first letter
        return filename:sub(1, 1):upper() .. filename:sub(2)
      end

      -- Define React snippets once
      local react_snippets = {
        -- sfc: default export
        s('sfc', {
          t 'const ',
          f(get_component_name, {}),
          t { ' = (): React.JSX.Element => {', '  return (', '    <div>' },
          f(get_component_name, {}),
          t { '</div>', '  )', '}', '', 'export default ' },
          f(get_component_name, {}),
          i(0),
        }),

        -- sfce: named export
        s('sfce', {
          t 'export const ',
          f(get_component_name, {}),
          t { ' = (): React.JSX.Element => {', '  return (', '    <div>' },
          f(get_component_name, {}),
          t { '</div>', '  )', '}' },
          i(0),
        }),
      }

      -- Apply snippets to all React/TypeScript filetypes
      ls.add_snippets('typescript', react_snippets)
      ls.add_snippets('typescriptreact', react_snippets)
      ls.add_snippets('javascriptreact', react_snippets)

      -- Keymaps for snippet navigation
      vim.keymap.set({ 'i', 's' }, '<C-k>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true, desc = 'Expand or jump snippet' })

      vim.keymap.set({ 'i', 's' }, '<C-j>', function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true, desc = 'Jump back in snippet' })

      vim.keymap.set('i', '<C-l>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { desc = 'Change snippet choice' })
    end,
  },
}
