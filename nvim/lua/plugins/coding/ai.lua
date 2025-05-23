return {
  {
    'zbirenbaum/copilot.lua',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = { enabled = false },
        suggestion = {
          enabled = false,
          auto_trigger = false,
          debounce = 20, -- Faster response time (default: 75)
          throttle = 60, -- Lower refresh interval (default: 100)
        },
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    after = { 'copilot.lua', 'nvim-cmp' },
    config = function()
      require('copilot_cmp').setup()
    end,
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = '*', -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = 'qwen', -- Set the default provider to 'claude'
      auto_suggestions_provider = 'copilot',
      behaviour = {
        auto_suggestions = true,
      },
      gemini = {
        api_key = vim.env.GEMINI_API_KEY,
        model = 'models/gemini-2.5-flash-preview-04-17',
      },
      anthropic = {
        api_key = vim.env.ANTHROPIC_API_KEY,
        model = 'claude-3-7-sonnet-20250219',
      },
      web_search_engine = {
        provider = 'google', -- Set Google as the web search provider
      },
      vendors = {
        qwen = {
          __inherited_from = 'openai',
          api_key_name = 'DASHSCOPE_API_KEY',
          endpoint = 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1',
          model = 'qwen-max-2025-01-25',
        },
      },
    },
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'echasnovski/mini.icons', -- or nvim-tree/nvim-web-devicons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- web search engine provider
            web_search_engine = {
              provider = 'google', -- tavily, serpapi, searchapi, google or kagi
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
