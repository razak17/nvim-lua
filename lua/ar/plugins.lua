---Join path segments that were passed as input
---@return string
function join_paths(...)
  local path_sep = vim.uv.os_uname().version:match('Windows') and '\\' or '/'
  local result = table.concat({ ... }, path_sep)
  return result
end

local function has_words_before()
  local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match('%s')
      == nil
end

return {
  {
    'razak17/onedark.nvim',
    lazy = false,
    priority = 1000,
    opts = { variant = 'fill' },
    config = function(_, opts) require('onedark').setup(opts) end,
  },
  {
    'xiyaowong/accelerated-jk.nvim',
    event = 'VeryLazy',
    config = function()
      require('accelerated-jk').setup({
        mappings = { j = 'gj', k = 'gk' },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    version = false, -- last release is way too old and doesn't work on Windows
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        auto_install = true,
        highlight = { enable = true },
        ensure_installed = { 'lua' },
      })
    end,
  },
  {

    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = {},
    },
    keys = {
      {
        '<leader>sp',
        function() Snacks.picker.lazy() end,
        desc = 'Search for Plugin Spec',
      },
      {
        '<C-p>',
        function()
          Snacks.picker.files({
            finder = 'files',
            format = 'file',
            show_empty = true,
            supports_live = true,
            -- In case you want to override the layout for this keymap
            -- layout = "vscode",
          })
        end,
        desc = 'Find Files',
      },
    },
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
      -- stylua: ignore
      keys = {
        { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
        { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
        { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
        { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
      },
  },
  {
    'chrisgrieser/nvim-origami',
    -- event = "BufReadPost",
    keys = {
      {
        '<BS>',
        function() require('origami').h() end,
        desc = 'toggle fold',
      },
    },
    opts = { setupFoldKeymaps = false },
  },
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
      -- stylua: ignore
      keys = {
        { '<localleader>gs', function() require('neogit').open() end, desc = 'open status buffer', },
        { '<localleader>gc', function() require('neogit').open({ 'commit' }) end, desc = 'open commit buffer', },
        { '<localleader>gl', function() require('neogit.popups.pull').create() end, desc = 'open pull popup', },
        { '<localleader>gp', function() require('neogit.popups.push').create() end, desc = 'open push popup', },
      },
    opts = {
      disable_signs = false,
      disable_hint = true,
      disable_commit_confirmation = true,
      disable_builtin_notifications = true,
      disable_insert_on_commit = false,
      disable_context_highlighting = true,
      signs = {
        item = { '▸', '▾' },
        hunk = { '樂', '' },
      },
      integrations = {
        diffview = true,
      },
    },
  },
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
    event = { 'User KittyScrollbackLaunch' },
    config = function() require('kitty-scrollback').setup() end,
  },
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
      -- stylua: ignore
      keys = {
        { '<localleader>gs', function() require('neogit').open() end, desc = 'open status buffer', },
        { '<localleader>gc', function() require('neogit').open({ 'commit' }) end, desc = 'open commit buffer', },
        { '<localleader>gl', function() require('neogit.popups.pull').create() end, desc = 'open pull popup', },
        { '<localleader>gp', function() require('neogit.popups.push').create({}) end, desc = 'open push popup', },
      },
    opts = {
      disable_signs = false,
      disable_hint = true,
      disable_commit_confirmation = true,
      disable_builtin_notifications = true,
      disable_insert_on_commit = false,
      disable_context_highlighting = true,
      signs = {
        item = { '▸', '▾' },
        hunk = { '樂', '' },
      },
      integrations = { diffview = true },
      graph_style = 'kitty',
    },
    config = function(_, opts) require('neogit').setup(opts) end,
  },
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    build = 'make install_jsregexp',
    keys = {
      { '<leader>S', '<cmd>LuaSnipEdit<CR>', desc = 'LuaSnip: edit snippet' },
    },
    config = function()
      local ls = require('luasnip')
      local types = require('luasnip.util.types')
      local extras = require('luasnip.extras')
      local fmt = require('luasnip.extras.fmt').fmt

      ls.config.set_config({
        history = false,
        region_check_events = 'CursorMoved,CursorHold,InsertEnter',
        delete_check_events = 'InsertLeave',
        ext_opts = {
          [types.choiceNode] = {
            active = {
              hl_mode = 'combine',
              virt_text = { { '●', 'Operator' } },
            },
          },
          [types.insertNode] = {
            active = {
              hl_mode = 'combine',
              virt_text = { { '●', 'Type' } },
            },
          },
        },
        enable_autosnippets = true,
        snip_env = {
          fmt = fmt,
          m = extras.match,
          t = ls.text_node,
          f = ls.function_node,
          c = ls.choice_node,
          d = ls.dynamic_node,
          i = ls.insert_node,
          l = extras.lamda,
          snippet = ls.snippet,
        },
      })

      -- <c-l> is selecting within a list of options.
      -- vim.keymap.set({ 's', 'i' }, '<c-l>', function()
      --   if ls.choice_active() then ls.change_choice(1) end
      -- end)

      vim.keymap.set({ 's', 'i' }, '<c-l>', function()
        if ls.expand_or_jumpable() then ls.expand_or_jump() end
      end)

      vim.keymap.set({ 's', 'i' }, '<c-b>', function()
        if not ls.jumpable(-1) then return '<S-Tab>' end
        ls.jump(-1)
      end)

      require('luasnip').config.setup({ store_selection_keys = '<C-x>' })

      require('luasnip.loaders.from_lua').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load({
        paths = {
          join_paths(vim.fn.stdpath('data'), 'lazy', 'friendly-snippets'),
          join_paths(vim.fn.stdpath('config'), 'snippets', 'textmate'),
        },
      })

      ls.filetype_extend('typescriptreact', { 'javascript', 'typescript' })
      ls.filetype_extend('NeogitCommitMessage', { 'gitcommit' })
    end,
  },
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '*', -- REQUIRED `version` needed to download pre-built binary
    opts_extend = {
      'sources.completion.enabled_providers',
      -- 'sources.compat',
      'sources.default',
      'cmdline.sources',
      'term.sources',
    },
    opts = {
      enabled = function()
        local ignored_filetypes = {
          'TelescopePrompt',
          'minifiles',
          'snacks_picker_input',
          'neo-tree-popup',
          'dropbar_menu_fzf',
        }
        local filetype = vim.bo[0].filetype
        return not vim.tbl_contains(ignored_filetypes, filetype)
      end,
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      signature = { window = { border = border } },
      cmdline = {
        keymap = {
          preset = 'cmdline',
          -- recommended, as the default keymap will only show and select the next item
          ['<Tab>'] = { 'show', 'select_next' },
          ['<S-Tab>'] = { 'show', 'select_prev' },
          ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
        enabled = true,
        completion = {
          ghost_text = { enabled = false },
          list = { selection = { preselect = false, auto_insert = true } },
          menu = {
            auto_show = function(ctx)
              local type = vim.fn.getcmdtype()
              if ctx.mode == 'cmdline' then
                return type == ':' or type == '@'
              end
              return false
            end,
          },
        },
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == '/' or type == '?' then return { 'buffer' } end
          if type == ':' then return { 'cmdline' } end
          return {}
        end,
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = { enabled = true },
        },
        -- Recommended to avoid unnecessary request
        trigger = { prefetch_on_insert = false },
        menu = {
          border = border,
          winblend = 0,
          winhighlight = 'NormalFloat:NormalFloat,CursorLine:PmenuSel,NormalFloat:NormalFloat',
          draw = {
            columns = {
              { 'label', gap = 1 },
              { 'kind_icon', gap = 2, 'source_name' },
            },
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = border },
        },
        ghost_text = { enabled = false },
        list = { selection = { preselect = false, auto_insert = true } },
      },
      sources = {
        default = function()
          local node = vim.treesitter.get_node()
          local providers = {
            'lsp',
            'path',
            'snippets',
            'buffer',
            'ripgrep',
            'emoji',
          }

          if
            node
            and vim.tbl_contains(
              { 'comment', 'line_comment', 'block_comment' },
              node:type()
            )
          then
            return { 'buffer' }
          else
            return providers
          end
        end,
        providers = {
          lsp = {
            name = '[LSP]',
            score_offset = 35,
          },
          path = {
            name = '[PATH]',
            score_offset = 25,
            opts = { show_hidden_files_by_default = true },
          },
          buffer = { name = '[BUF]' },
          cmdline = {
            name = '[CMD]',
            min_keyword_length = function(ctx)
              -- when typing a command, only show when the keyword is 3 characters or longer
              if
                ctx.mode == 'cmdline' and string.find(ctx.line, ' ') == nil
              then
                return 3
              end
              return 0
            end,
          },
          snippets = {
            enabled = true,
            name = '[SNIP]',
            max_items = 15,
            module = 'blink.cmp.sources.snippets',
            score_offset = 20,
          },
          ripgrep = {
            module = 'blink-ripgrep',
            name = '[RG]',
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.kind = require('blink.cmp.types').CompletionItemKind.Field
              end
              return items
            end,
            opts = { prefix_min_len = 5 },
          },
          emoji = {
            module = 'blink-emoji',
            name = '[EMOJI]',
            score_offset = 15,
            min_keyword_length = 2,
            opts = { insert = true },
          },
        },
      },
      keymap = {
        preset = 'default',
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-l>'] = { 'accept', 'fallback' },
        ['<C-n>'] = { 'select_next', 'show' },
        ['<C-p>'] = { 'select_prev', 'show' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-space>'] = {
          'show',
          'show_documentation',
          'hide_documentation',
          'fallback',
        },
        ['<Tab>'] = {
          'select_next',
          'snippet_forward',
          function(cmp)
            if has_words_before() or api.nvim_get_mode().mode == 'c' then
              return cmp.show()
            end
          end,
          'fallback',
        },
        ['<S-Tab>'] = {
          'select_prev',
          'snippet_backward',
          function(cmp)
            if api.nvim_get_mode().mode == 'c' then return cmp.show() end
          end,
          'fallback',
        },
        ['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
        ['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
        ['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
        ['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
        ['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
        ['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
        ['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
        ['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
        ['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
        ['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
      },
    },
    config = function(_, opts) require('blink.cmp').setup(opts) end,
    dependencies = {
      'rafamadriz/friendly-snippets',
      'mikavilpas/blink-ripgrep.nvim',
      'L3MON4D3/LuaSnip',
      'moyiz/blink-emoji.nvim',
      {
        'saghen/blink.compat',
        version = '*',
        opts = { impersonate_nvim_cmp = true },
      },
    },
  },
}
