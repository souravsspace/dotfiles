return {
  {
    'mason-org/mason.nvim',
    opts = { ensure_installed = { 'biome' } },
  },
  {
    'stevearc/conform.nvim',
    event = 'VeryLazy',
    opts = {
      notify_on_error = false,
      format_on_save = false,
      formatters_by_ft = {
        javascript = { 'biome', 'biome-organize-imports' },
        javascriptreact = { 'biome', 'biome-organize-imports' },
        typescript = { 'biome', 'biome-organize-imports' },
        typescriptreact = { 'biome', 'biome-organize-imports' },
      },
    },
    config = function(_, opts)
      local ok, conform = pcall(require, 'conform')
      if not ok then
        vim.notify('conform.nvim failed to load', vim.log.levels.ERROR)
        return
      end

      conform.setup(opts)

      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
        callback = function(args)
          local bufnr = args.buf
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end

          local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
          if
            not (
              ft == 'javascript'
              or ft == 'javascriptreact'
              or ft == 'typescript'
              or ft == 'typescriptreact'
            )
          then
            return
          end

          if vim.fn.executable 'biome' == 0 then
            vim.notify(
              'biome not found in PATH — auto-format skipped',
              vim.log.levels.WARN
            )
            return
          end

          conform.format {
            bufnr = bufnr,
            async = true,
            lsp_format = 'never',
            timeout_ms = 1000,
          }

          vim.defer_fn(function()
            if
              vim.api.nvim_buf_is_valid(bufnr)
              and vim.api.nvim_buf_get_option(bufnr, 'modified')
            then
              vim.api.nvim_buf_call(bufnr, function()
                vim.cmd 'silent noautocmd write'
              end)
            end
          end, 300)
        end,
      })
    end,
  },
}
