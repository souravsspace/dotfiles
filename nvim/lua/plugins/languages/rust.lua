local diagnostics = 'rust-analyzer'

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
    'mrcjkb/rustaceanvim',
    ft = { 'rust' },
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
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
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = diagnostics == 'rust-analyzer',
            diagnostics = {
              enable = diagnostics == 'rust-analyzer',
            },
            procMacro = {
              enable = true,
            },
            files = {
              exclude = {
                '.direnv',
                '.git',
                '.jj',
                '.github',
                '.gitlab',
                'bin',
                'node_modules',
                'target',
                'venv',
                '.venv',
              },
              watcher = 'client',
            },
          },
        },
      },
    },

    config = function(_, opts)
      -- Compute caps lazily here so cmp-nvim-lsp is on rtp (it's a declared dep).
      -- Doing this at opts-eval time returns base caps and breaks completions
      -- past `::` because rust-analyzer is init'd without
      -- resolveSupport/snippetSupport/labelDetailsSupport.
      local caps = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      if ok then
        caps = cmp_nvim_lsp.default_capabilities(caps)
      end
      caps.textDocument.completion.completionItem.labelDetailsSupport = true
      caps.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      opts.server = opts.server or {}
      opts.server.capabilities =
        vim.tbl_deep_extend('force', caps, opts.server.capabilities or {})

      local has_mason = pcall(require, 'mason')
      if has_mason then
        local codelldb = vim.fn.exepath 'codelldb'
        local uname = vim.uv.os_uname().sysname
        local codelldb_lib_ext = uname == 'Linux' and '.so' or '.dylib'
        local library_path =
          vim.fn.expand('$MASON/opt/lldb/lib/liblldb' .. codelldb_lib_ext)

        opts.dap = {
          adapter = require('rustaceanvim.config').get_codelldb_adapter(
            codelldb,
            library_path
          ),
        }
      end

      vim.g.rustaceanvim =
        vim.tbl_deep_extend('force', vim.g.rustaceanvim or {}, opts or {})

      if vim.fn.executable 'rust-analyzer' == 0 then
        vim.notify(
          '**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/',
          vim.log.levels.ERROR,
          { title = 'rustaceanvim' }
        )
      end
    end,
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        bacon_ls = {
          enabled = diagnostics == 'bacon-ls',
        },
        rust_analyzer = {
          enabled = false,
        },
      },
    },
  },

  {
    'mason-org/mason.nvim',
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
    'nvim-neotest/neotest',
    optional = true,
    opts = {
      adapters = {
        ['rustaceanvim.neotest'] = {},
      },
    },
  },
}
