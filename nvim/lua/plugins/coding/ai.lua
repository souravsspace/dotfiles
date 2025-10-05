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

  -- Sidekick for Claude Code and advanced features
  {
    'folke/sidekick.nvim',
    dependencies = {
      'neovim/nvim-lspconfig', -- For Copilot LSP
    },
    opts = {
      nes = {
        enabled = true,
        debounce = 100,
      },
      cli = {
        tools = {
          claude = {
            cmd = { 'claude' },
            url = 'https://github.com/anthropics/claude-code',
          },
          copilot = {
            cmd = { 'gh', 'copilot' },
            url = 'https://github.com/github/copilot-cli',
          },
        },
      },
    },
    keys = {
      -- Tab to accept/jump through inline suggestions
      {
        '<tab>',
        function()
          if not require('sidekick').nes_jump_or_apply() then
            return '<Tab>'
          end
        end,
        expr = true,
        mode = { 'i', 'n' },
        desc = 'Jump/Apply Next Edit Suggestion',
      },
      -- Toggle Claude Code terminal
      {
        '<leader>ac',
        function()
          require('sidekick.cli').toggle { name = 'claude', focus = true }
        end,
        desc = 'Sidekick: Claude Code',
        mode = { 'n', 'v' },
      },
      -- Toggle generic AI CLI
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle { focus = true }
        end,
        desc = 'Sidekick: Toggle CLI',
        mode = { 'n', 'v' },
      },
      -- Prompt selector
      {
        '<leader>ap',
        function()
          require('sidekick.cli').select_prompt()
        end,
        desc = 'Sidekick: Ask Prompt',
        mode = { 'n', 'v' },
      },
    },
  },

  -- Enable the following to use Avante + MCP Hub

  -- {
  --   'yetone/avante.nvim',
  --   event = 'VeryLazy',
  --   version = '*', -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
  --   opts = {
  --     provider = 'qwen', -- Set the default provider to 'claude'
  --     providers = {
  --       auto_suggestions_provider = 'copilot',
  --       behaviour = {
  --         auto_suggestions = true,
  --       },
  --       gemini = {
  --         api_key = vim.env.GEMINI_API_KEY,
  --         model = 'models/gemini-2.5-flash-preview-04-17',
  --       },
  --       anthropic = {
  --         api_key = vim.env.ANTHROPIC_API_KEY,
  --         model = 'claude-3-7-sonnet-20250219',
  --       },
  --       web_search_engine = {
  --         provider = 'google', -- Set Google as the web search provider
  --       },
  --       qwen = {
  --         __inherited_from = 'openai',
  --         api_key_name = 'DASHSCOPE_API_KEY',
  --         endpoint = 'https://dashscope-intl.aliyuncs.com/compatible-mode/v1',
  --         model = 'qwen3-coder-plus',
  --       },
  --     },
  --
  --     -- ***** MCP Hub integration *****
  --     system_prompt = function()
  --       local hub = require('mcphub').get_hub_instance()
  --       return hub and hub:get_active_servers_prompt() or ''
  --     end,
  --     custom_tools = function()
  --       return {
  --         require('mcphub.extensions.avante').mcp_tool(),
  --       }
  --     end,
  --   },
  --   build = 'make',
  --   dependencies = {
  --     'nvim-treesitter/nvim-treesitter',
  --     'stevearc/dressing.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --     --- The below dependencies are optional,
  --     'echasnovski/mini.pick', -- for file_selector provider mini.pick
  --     'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
  --     'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
  --     'ibhagwan/fzf-lua', -- for file_selector provider fzf
  --     'echasnovski/mini.icons', -- or nvim-tree/nvim-web-devicons
  --     'zbirenbaum/copilot.lua', -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       'HakonHarnes/img-clip.nvim',
  --       event = 'VeryLazy',
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- web search engine provider
  --           web_search_engine = {
  --             provider = 'google', -- tavily, serpapi, searchapi, google or kagi
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { 'markdown', 'Avante' },
  --       },
  --       ft = { 'markdown', 'Avante' },
  --     },
  --   },
  -- },
  -- {
  --   'ravitemer/mcphub.nvim',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --   },
  --   build = 'npm install -g mcp-hub@latest', -- Installs `mcp-hub` node binary globally
  --   config = function()
  --     require('mcphub').setup {
  --       --- `mcp-hub` binary related options-------------------
  --       config = vim.fn.expand '~/.config/mcphub/servers.json', -- Absolute path to MCP Servers config file (will create if not exists)
  --       port = 37373, -- The port `mcp-hub` server listens to
  --       shutdown_delay = 60 * 10 * 000, -- Delay in ms before shutting down the server when last instance closes (default: 10 minutes)
  --       use_bundled_binary = false, -- Use local `mcp-hub` binary (set this to true when using build = "bundled_build.lua")
  --
  --       ---Chat-plugin related options-----------------
  --       auto_approve = false, -- Auto approve mcp tool calls
  --       auto_toggle_mcp_servers = true, -- Let LLMs start and stop MCP servers automatically
  --       extensions = {
  --         avante = {
  --           make_slash_commands = true, -- make /slash commands from MCP server prompts
  --         },
  --       },
  --
  --       --- Plugin specific options-------------------
  --       native_servers = {}, -- add your custom lua native servers here
  --       ui = {
  --         window = {
  --           width = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
  --           height = 0.8, -- 0-1 (ratio); "50%" (percentage); 50 (raw number)
  --           relative = 'editor',
  --           zindex = 50,
  --           border = 'rounded', -- "none", "single", "double", "rounded", "solid", "shadow"
  --         },
  --         wo = { -- window-scoped options (vim.wo)
  --           winhl = 'Normal:MCPHubNormal,FloatBorder:MCPHubBorder',
  --         },
  --       },
  --       on_ready = function(hub)
  --         -- Called when hub is ready
  --       end,
  --       on_error = function(err)
  --         -- Called on errors
  --       end,
  --       log = {
  --         level = vim.log.levels.WARN,
  --         to_file = false,
  --         file_path = nil,
  --         prefix = 'MCPHub',
  --       },
  --     }
  --   end,
  -- },
}
