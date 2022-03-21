-- Setup nvim-cmp.
  local cmp = require'cmp'
  local lspkind = require('lspkind')

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    formatting = {
      format = lspkind.cmp_format({
      mode = "symbol_text",
      menu = ({
        nvim_lsp = "[LSP]",
        vsnip = "[Vsnip]",
        dictionary = "[Dict]",
        buffer = "[Buffer]",
        treesitter = "[Treesitter]",
        nvim_lsp_document_symbol = "[LSP]",
        rg = "[Rg]",
        nvim_lsp_signature_help = "[LSP]",
        path = "[Path]",
        cmdline = "[Cmdline]",
        latex_symbols = "[Latex]",
      })
    })
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
     ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      { name = "dictionary"}, 
      { name = 'buffer' },
      { name = 'treesitter' },
      { name = 'nvim_lsp_document_symbol' },
      { name = 'rg' },
      { name = 'nvim_lsp_signature_help' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  -- vim.api.nvim_set_keymap('n', '<space>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_set_keymap('n', '<leader>d', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local util = require 'lspconfig.util'
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig').ccls.setup {
    on_attach = on_attach;
    cmd ={"ccls"};
    filetypes = {"c", "cpp", "ipp", "cuda","ic","objc", "objcpp"};
    root_dir = util.root_pattern("compile_commands.json", ".ccls",".git",".svn");
    init_options = {
      cache= {
											directory=".tmp/ccls_cache/";
                               retainInMemory= 1;
															 format ="json";
															 hierarchicalPath = false
                               };
                             clang={
                    pathMappings={}
										};
                    index = {
                      trackDependency = 1;
                              threads = 4
                              };
                    completion = {
                              caseSensitivity= 2;
                              detailedLabel=true;
                              filterAndSort=true
                            };
                    highlight = {
                              lsRanges= true
                            };
						client = {
											snippetSupport=true
										};
                  }
  }

  -- Setup nvim-tree
  require'nvim-tree'.setup {
    -- 关闭文件时自动关闭
    auto_close = true,
    open_on_tab = false,
    open_on_setup = false,
    disable_netrw = true,
    update_focused_file = {
      enable      = true,
      update_cwd  = false,
      ignore_list = {}
    },
    -- 不显示 git 状态图标
    git = {
        enable = true
    },
    view = {
      mappings = 
    {
      custom_only = true,
      list = {
         { key = {"<CR>", "o", "<2-LeftMouse>"}, action = "edit" },
         { key = "<leader>e",                        action = "edit_in_place" },
         { key = {"O"},                          action = "edit_no_picker" },
         { key = {"<2-RightMouse>", "<C-]>"},    action = "cd" },
         { key = "<leader>v",                        action = "vsplit" },
         { key = "<leader>x",                        action = "split" },
         { key = "<leader>t",                        action = "tabnew" },
         { key = "<",                            action = "prev_sibling" },
         { key = ">",                            action = "next_sibling" },
         { key = "P",                            action = "parent_node" },
         { key = "<BS>",                         action = "close_node" },
         { key = "<Tab>",                        action = "preview" },
         { key = "K",                            action = "first_sibling" },
         { key = "J",                            action = "last_sibling" },
         { key = "I",                            action = "toggle_git_ignored" },
         { key = "H",                            action = "toggle_dotfiles" },
         { key = "R",                            action = "refresh" },
         { key = "a",                            action = "create" },
         { key = "d",                            action = "remove" },
         { key = "D",                            action = "trash" },
         { key = "r",                            action = "rename" },
         { key = "<leader>r",                        action = "full_rename" },
         { key = "x",                            action = "cut" },
         { key = "c",                            action = "copy" },
         { key = "p",                            action = "paste" },
         { key = "y",                            action = "copy_name" },
         { key = "Y",                            action = "copy_path" },
         { key = "gy",                           action = "copy_absolute_path" },
         { key = "[c",                           action = "prev_git_item" },
         { key = "]c",                           action = "next_git_item" },
         { key = "-",                            action = "dir_up" },
         { key = "s",                            action = "system_open" },
         { key = "q",                            action = "close" },
         { key = "g?",                           action = "toggle_help" },
         { key = "W",                            action = "collapse_all" },
         { key = "S",                            action = "search_node" },
         { key = "<leader>k",                        action = "toggle_file_info" },
         { key = ".",                            action = "run_file_command" },
      }
    }
    }
  }

  require'nvim-web-devicons'.setup {
    -- your personnal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    -- override = {
    --  zsh = {
    --    icon = "",
    --    color = "#428850",
    --    cterm_color = "65",
    --    name = "Zsh"
    --  }
    -- };
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = false;
  }   

  local actions = require('telescope.actions')
  require('telescope').setup{
    --local opts = {noremap = true, slient = true}
    defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      -- path_display = "smart";
            color_devicons = false,
            -- Format path as "file.txt (path\to\file\)"
            path_display = function(opts, path)
              -- local tail = require("telescope.utils").path_tail(path)
              local smart = require("telescope.utils").path_smart(path)
              return string.format("%s", smart)
            end,
      mappings = {
         i = {
          ["<C-n>"] = actions.move_selection_next,
          ["<C-p>"] = actions.move_selection_previous,
          ["<C-c>"] = actions.close,
          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["<CR>"] = actions.select_default,
          ["<leader>x"] = actions.select_horizontal,
          ["<leader>v"] = actions.select_vertical,
          ["<leader>t"] = actions.select_tab,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-l>"] = actions.complete_tag,
          ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          ["<C-w>"] = { "<c-s-w>", type = "command" },
        },

        n = {
          ["<esc>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<leader>x"] = actions.select_horizontal,
          ["<leader>v"] = actions.select_vertical,
          ["<leader>t"] = actions.select_tab,
          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["H"] = actions.move_to_top,
          ["M"] = actions.move_to_middle,
          ["L"] = actions.move_to_bottom,
          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,
          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,
          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,
          ["?"] = actions.which_key,
        },
      }
    },
    pickers = {
      -- Default configuration for builtin pickers goes here:
      -- picker_name = {
      --   picker_config_key = value,
      --   ...
      -- }
      -- Now the picker_config_key will be applied every time you call this
      -- builtin picker
    },
    extensions = {
      -- Your extension configuration goes here:
      -- extension_name = {
      --   extension_config_key = value,
      -- }
      -- please take a look at the readme of the extension you want to configure
      fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
      },
      file_browser = {
        theme = "ivy",
        -- picker = {
        --   cwd_to_path = true,
        -- },
        mappings = {
          ["i"] = {
            -- your custom insert mode mappings
          },
          ["n"] = {
            -- your custom normal mode mappings
          },
        },
      },
    }
  }
  require('telescope').load_extension('fzf')
  require("telescope").load_extension "file_browser"
  -- require("telescope").extensions.file_browser.picker_.file_browser{
  --  cwd_to_path = true; 
  -- }

  local gps = require("nvim-gps")
  require('lualine').setup {
    options = {
      icons_enabled = false,
      theme = 'horizon',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename', { gps.get_location, cond = gps.is_available },'lsp_progress'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  }

  require'nvim-treesitter.configs'.setup {
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    -- ensure_installed = "maintained",
    ensure_installed = {"c","cpp","bash"},

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing
    ignore_install = { "" },

    highlight = {
      -- `false` will disable the whole extension
      enable = true,

      -- list of language that will be disabled
      disable = {},

      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        -- init_selection = "gnn",
        -- node_incremental = "grn",
        -- scope_incremental = "grc",
        -- node_decremental = "grm",
      }
    },
    indent = {
      enable = true
    },
    rainbow = {
      enable = true,
      -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
      extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
      max_file_lines = nil, -- Do not enable for files with more than n lines, int
      -- colors = {}, -- table of hex strings
      -- termcolors = {} -- table of colour name strings
    }
  }

  require('spellsitter').setup {
    -- Whether enabled, can be a list of filetypes, e.g. {'python', 'lua'}
    enable = true,
    }

  require('gitsigns').setup {
    signs = {
      add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
      change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
      delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
      changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
    yadm = {
      enable = false
    },
  }

  -- vim.opt.listchars:append("eol:↴")
  
  require("indent_blankline").setup {
    enabled = false,
    use_treesitter = true,
    show_current_context = true,
    show_current_context_start = true,
    char_list = {'|', '¦', '┆', '┊'}

  }

  require('Comment').setup()

  require('nvim_context_vt').setup({
    -- Enable by default. You can disable and use :NvimContextVtToggle to maually enable.
    -- Default: true
    enabled = true,
  
    -- Override default virtual text prefix
    -- Default: '-->'
    prefix = '->',
  
    -- Override the internal highlight group name
    -- Default: 'ContextVt'
    -- highlight = 'CustomContextVt',
  
    -- Disable virtual text for given filetypes
    -- Default: { 'markdown' }
    disable_ft = { 'markdown' },
  
    -- Disable display of virtual text below blocks for indentation based languages like Python
    -- Default: false
    disable_virtual_lines = false,
  
    -- Same as above but only for spesific filetypes
    -- Default: {}
    disable_virtual_lines_ft = { 'yaml' },
  
    -- How many lines required after starting position to show virtual text
    -- Default: 1 (equals two lines total)
    min_rows = 1,
  
    -- Same as above but only for spesific filetypes
    -- Default: {}
    min_rows_ft = {},
  
  -- -- Custom virtual text node parser callback
  -- -- Default: nil
  -- custom_parser = function(node, ft, opts)
  --   local ts_utils = require('nvim-treesitter.ts_utils')

  --   -- If you return `nil`, no virtual text will be displayed.
  --   if node:type() == 'function' then
  --     return nil
  --   end

  --   -- This is the standard text
  --   return '--> ' .. ts_utils.get_node_text(node)[1]
  -- end,

  -- -- Custom node validator callback
  -- -- Default: nil
  -- custom_validator = function(node, ft, opts)
  --   -- Internally a node is matched against min_rows and configured targets
  --   local default_validator = require('nvim_context_vt.utils').default_validator
  --   if default_validator(node, ft) then
  --     -- Custom behaviour after using the internal validator
  --     if node:type() == 'function' then
  --       return false
  --     end
  --   end

  --   return true
  -- end,

  -- -- Custom node virtual text resolver callback
  -- -- Default: nil
  -- custom_resolver = function(nodes, ft, opts)
  --   -- By default the last node is used
  --   return nodes[#nodes]
  -- end,
  })


  require("nvim-gps").setup({

	  disable_icons = true,           -- Setting it to true will disable all icons

	  icons = {
	  	["class-name"] = ' ',      -- Classes and class-like objects
	  	["function-name"] = ' ',   -- Functions
	  	["method-name"] = ' ',     -- Methods (functions inside class-like objects)
	  	["container-name"] = '⛶ ',  -- Containers (example: lua tables)
	  	["tag-name"] = '炙'         -- Tags (example: html tags)
	  },

	  -- Add custom configuration per language or
	  -- Disable the plugin for a language
	  -- Any language not disabled here is enabled by default
	  languages = {

	  	-- Disable for particular languages
	  	-- ["bash"] = false, -- disables nvim-gps for bash
	  	-- ["go"] = false,   -- disables nvim-gps for golang

	  	-- Override default setting for particular languages
	  	-- ["ruby"] = {
	  	--	separator = '|', -- Overrides default separator with '|'
	  	--	icons = {
	  	--		-- Default icons not specified in the lang config
	  	--		-- will fallback to the default value
	  	--		-- "container-name" will fallback to default because it's not set
	  	--		["function-name"] = '',    -- to ensure empty values, set an empty string
	  	--		["tag-name"] = ''
	  	--		["class-name"] = '::',
	  	--		["method-name"] = '#',
	  	--	}
	  	--}
	  },

	  separator = ' @ ',

	  -- limit for amount of context shown
	  -- 0 means no limit
	  depth = 1,

	  -- indicator used when context hits depth limit
	  depth_limit_indicator = "..."
  })  