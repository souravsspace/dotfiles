return {
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- Disable rust-analyzer from lspconfig since it's handled by rustaceanvim
        rust_analyzer = false,
        bacon_ls = {
          enabled = diagnostics == 'bacon-ls',
        },
      },
    },
  },
  {
    'williamboman/mason.nvim',
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'codelldb' })
      if diagnostics == 'bacon-ls' then
        vim.list_extend(opts.ensure_installed, { 'bacon' })
      end
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = vim.fn.has 'nvim-0.10.0' == 0 and '^4' or false,
    ft = { 'rust' },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set('n', '<leader>cR', function()
            vim.cmd.RustLsp 'codeAction'
          end, { desc = 'Code Action', buffer = bufnr })
          vim.keymap.set('n', '<leader>dr', function()
            vim.cmd.RustLsp 'debuggables'
          end, { desc = 'Rust Debuggables', buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust
            checkOnSave = true,
            -- Enable diagnostics
            diagnostics = {
              enable = true,
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
            files = {
              excludeDirs = {
                '.direnv',
                '.git',
                '.github',
                '.gitlab',
                'bin',
                'node_modules',
                'target',
                'venv',
                '.venv',
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      if require('lazy.core.config').plugins['mason.nvim'] then
        local mason_data = vim.fn.stdpath 'data' .. '/mason/packages'

        local pkg_dir = mason_data .. '/codelldb'

        local codelldb = pkg_dir .. '/extension/adapter/codelldb'
        if vim.fn.has 'win32' == 1 then
          codelldb = codelldb .. '.exe'
        end

        local liblldb
        if vim.fn.has 'mac' == 1 then
          liblldb = pkg_dir .. '/extension/lldb/lib/liblldb.dylib'
        else
          liblldb = pkg_dir .. '/extension/lldb/lib/liblldb.so'
        end

        opts.dap = {
          adapter = require('rustaceanvim.config').get_codelldb_adapter(
            codelldb,
            liblldb
          ),
        }
      end
      vim.g.rustaceanvim =
        vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
    end,
  },
  {
    'nvim-neotest/neotest',
    optional = true,
    opts = {
      adapters = {
        ['rustaceanvim.neotest'] = {},
      },
    },
  },
}
