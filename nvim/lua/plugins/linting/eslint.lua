return {
  "neovim/nvim-lspconfig",
  -- other settings removed for brevity
  opts = {
    ---@type table<string, vim.lsp.Config>
    servers = {
      eslint = {
        settings = {
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          workingDirectories = { mode = "auto" },
          format = vim.g.lazyvim_eslint_auto_format or true,
        },
      },
    },
    setup = {
      eslint = function()
        local auto_format = vim.g.lazyvim_eslint_auto_format
        if auto_format == false then
          return
        end

        local formatter = LazyVim.lsp.formatter({
          name = "eslint: lsp",
          primary = false,
          priority = 200,
          filter = "eslint",
        })

        -- register the formatter with LazyVim
        LazyVim.format.register(formatter)
      end,
    },
  },
}