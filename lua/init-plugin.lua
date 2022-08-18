  require('lspkind').init({
      -- DEPRECATED (use mode instead): enables text annotations
      --
      -- default: true
      -- with_text = true,
  
      -- defines how annotations are shown
      -- default: symbol
      -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
      mode = 'symbol_text',
  
      -- default symbol map
      -- can be either 'default' (requires nerd-fonts font) or
      -- 'codicons' for codicon preset (requires vscode-codicons font)
      --
      -- default: 'default'
      preset = 'codicons',
  
      -- override preset symbols
      --
      -- default: {}
      symbol_map = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = ""
      },
  })

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
      -- menu = ({
      --   nvim_lsp = "[LSP]",
      --   vsnip = "[Vsnip]",
      --   dictionary = "[Dict]",
      --   buffer = "[Buffer]",
      --   treesitter = "[Treesitter]",
      --   nvim_lsp_document_symbol = "[LSP]",
      --   rg = "[Rg]",
      --   nvim_lsp_signature_help = "[LSP]",
      --   path = "[Path]",
      --   cmdline = "[Cmdline]",
      --   latex_symbols = "[Latex]",
      -- })
    })
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item, {'i','c'}
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      { name = "dictionary"}, 
      { name = 'buffer' },
      { name = 'treesitter' },
      { name = 'nvim_lsp_document_symbol' },
      -- { name = 'rg' },
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
    mapping = 
    {
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
    },
      -- cmp.mapping.preset.cmdline(),
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
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
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
    capabilities = capabilities;
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

  -- require('lspconfig').clangd.setup {
  --   on_attach = on_attach,
  --   flags = {
  --     -- This will be the default in neovim 0.7+
  --     debounce_text_changes = 150,
  --     filetypes = {"c", "cpp", "ipp", "cuda","ic","objc", "objcpp"};
  --     root_dir = util.root_pattern("compile_commands.json", ".ccls",".git",".svn");
  --   }
  -- }

  -- require("clangd_extensions").setup {
  --     server = {
  --         -- options to pass to nvim-lspconfig
  --         -- i.e. the arguments to require("lspconfig").clangd.setup({})
  --       "--limit-references=0",
  --       "--limit-results=0",
  --       "--inlay-hints",
  --       "--background-index",
  --       "--header-insertion = iwyu",
  --       "--clang-tidy",
  --       "-j=4",
  --       "--pch-storage=memory",
  --       "--malloc-trim",
  --     },
  --     extensions = {
  --         -- defaults:
  --         -- Automatically set inlay hints (type hints)
  --         autoSetHints = true,
  --         -- Whether to show hover actions inside the hover window
  --         -- This overrides the default hover handler
  --         hover_with_actions = true,
  --         -- These apply to the default ClangdSetInlayHints command
  --         inlay_hints = {
  --             -- Only show inlay hints for the current line
  --             only_current_line = false,
  --             -- Event which triggers a refersh of the inlay hints.
  --             -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
  --             -- not that this may cause  higher CPU usage.
  --             -- This option is only respected when only_current_line and
  --             -- autoSetHints both are true.
  --             only_current_line_autocmd = "CursorHold",
  --             -- whether to show parameter hints with the inlay hints or not
  --             show_parameter_hints = true,
  --             -- prefix for parameter hints
  --             parameter_hints_prefix = "<- ",
  --             -- prefix for all the other hints (type, chaining)
  --             other_hints_prefix = "=> ",
  --             -- whether to align to the length of the longest line in the file
  --             max_len_align = false,
  --             -- padding from the left if max_len_align is true
  --             max_len_align_padding = 1,
  --             -- whether to align to the extreme right or not
  --             right_align = false,
  --             -- padding from the right if right_align is true
  --             right_align_padding = 7,
  --             -- The color of the hints
  --             highlight = "Comment",
  --         },
  --         ast = {
  --             role_icons = {
  --                 type = "type",
  --                 declaration = "dec",
  --                 expression = "expr",
  --                 specifier = "spec",
  --                 statement = "stat",
  --                 ["template argument"] = "Targ",
  --             },
  -- 
  --             kind_icons = {
  --                 Compound = "-",
  --                 Recovery = "-",
  --                 TranslationUnit = "-",
  --                 PackExpansion = "-",
  --                 TemplateTypeParm = "-",
  --                 TemplateTemplateParm = "-",
  --                 TemplateParamObject = "-",
  --             },
  -- 
  --             highlights = {
  --                 detail = "Comment",
  --             },
  --         memory_usage = {
  --             border = "none",
  --         },
  --         symbol_info = {
  --             border = "none",
  --         },
  --     },
  --   },
  -- }

  -- Setup nvim-tree
  require'nvim-tree'.setup {
    -- 关闭文件时自动关闭
    open_on_tab = false,
    open_on_setup = false,
    disable_netrw = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable      = true,
      update_cwd  = false,
      ignore_list = {}
    },
    -- 不显示 git 状态图标
    git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        timeout = 400,
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
    },
    },
          renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = "none",
        root_folder_modifier = ":~",
        indent_markers = {
          enable = false,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            none = " ",
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = "before",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        symlink_destination = true,
      },

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
    default = true;
  }   

  local actions = require('telescope.actions')
  require('telescope').setup{
    --local opts = {noremap = true, slient = true}
    defaults = {
      -- Default configuration for telescope goes here:
      -- config_key = value,
      -- path_display = "smart";
            theme = everforest,
            color_devicons = true,
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

 --  local navic = require("nvim-navic")
	-- local components = {
	-- 	active = {{}, {}, {}},
	-- }
	-- table.insert(components.active[1], {
	-- 	provider = function()
	-- 		return navic.get_location()
	-- 	end,
	-- 	enabled = function() return navic.is_available() end,
	-- })
  -- local gps = require("nvim-gps")
  -- require('lualine').setup {
  --   options = {
  --     icons_enabled = false,
  --     theme = 'sonokai',
  --     component_separators = { left = '', right = ''},
  --     section_separators = { left = '', right = ''},
  --     disabled_filetypes = {},
  --     always_divide_middle = true,
  --   },
  --   sections = {
  --     lualine_a = {'mode'},
  --     lualine_b = {'branch', 'diff', 'diagnostics'},
  --     lualine_c = {{'filename',
  --                    file_status = true,
  --                    path = 1,
  --                    shorting_target=80,
  --                     symbols = {
  --
  --                       modified = '[+]',
  --                       readonly = '[-]',
  --                       unnamed = '[No Name]',
  --
  --                     }}
  --                   ,'lsp_progress'},
  --     lualine_x = {'encoding', 'fileformat', 'filetype'},
  --     lualine_y = {'progress'},
  --     lualine_z = {'location'}
  --   },
  --   inactive_sections = {
  --     lualine_a = {},
  --     lualine_b = {},
  --     lualine_c = {'filename'},
  --     lualine_x = {'location'},
  --     lualine_y = {},
  --     lualine_z = {}
  --   },
  --   -- winbar = {
  --   --   lualine_a = {{ gps.get_location, cond = gps.is_available }},
  --   --   lualine_b = {},
  --   --   -- lualine_b = { {navic.get_location, cond = navic.is_available} },
  --   --   lualine_c = {},
  --   --   lualine_x = {},
  --   --   lualine_y = {},
  --   --   lualine_z = {'location'}
  --   -- },
  --   -- inactive_winbar = {
  --   --   -- lualine_a = {'filename'},
  --   --   -- lualine_b = {},
  --   --   -- lualine_c = {},
  --   --   -- lualine_x = {},
  --   --   -- lualine_y = {},
  --   --   -- lualine_z = {'location'}
  --   -- },
  --   inactive_tabline= {},
  --   extensions = {}
  -- }
  -- require('feline').setup()
  -- require('feline').winbar.setup()

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
    update_debounce = 10,
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
    prefix = '炙',
  
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


  -- navic.setup {
  --    icons = {
  --        File          = " ",
  --        Module        = " ",
  --        Namespace     = " ",
  --        Package       = " ",
  --        Class         = " ",
  --        Method        = " ",
  --        Property      = " ",
  --        Field         = " ",
  --        Constructor   = " ",
  --        Enum          = "練",
  --        Interface     = "練",
  --        Function      = " ",
  --        Variable      = " ",
  --        Constant      = " ",
  --        String        = " ",
  --        Number        = " ",
  --        Boolean       = "◩ ",
  --        Array         = " ",
  --        Object        = " ",
  --        Key           = " ",
  --        Null          = "ﳠ ",
  --        EnumMember    = " ",
  --        Struct        = " ",
  --        Event         = " ",
  --        Operator      = " ",
  --        TypeParameter = " ",
  --    },
  --    highlight = false,
  --    separator = " > ",
  --    depth_limit = 0,
  --    depth_limit_indicator = "..",
  -- }

  require("nvim-gps").setup({

	  disable_icons = false,           -- Setting it to true will disable all icons

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

	  -- separator = ' @ ',

	  -- limit for amount of context shown
	  -- 0 means no limit
	  depth = 0,

	  -- indicator used when context hits depth limit
	  depth_limit_indicator = "..."
  })

-- require('bufferline').setup {
--   options = {
--     mode = "buffers", -- set to "tabs" to only show tabpages instead
--     numbers = function(opts)
--       return string.format('%s|%s', opts.lower(opts.id), opts.ordinal)
--     end,
--     -- close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
--     -- right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
--     -- left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
--     -- middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
--     -- NOTE: this plugin is designed with this icon in mind,
--     -- and so changing this is NOT recommended, this is intended
--     -- as an escape hatch for people who cannot bear it for whatever reason
--     indicator_icon = '▎',
--     buffer_close_icon = '',
--     modified_icon = '●',
--     close_icon = '',
--     left_trunc_marker = '',
--     right_trunc_marker = '',
--     --- name_formatter can be used to change the buffer's label in the bufferline.
--     --- Please note some names can/will break the
--     --- bufferline so use this at your discretion knowing that it has
--     --- some limitations that will *NOT* be fixed.
--     -- name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
--     --   -- remove extension from markdown files for example
--     --   if buf.name:match('%.md') then
--     --     return vim.fn.fnamemodify(buf.name, ':t:r')
--     --   end
--     -- end,
--     max_name_length = 18,
--     max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
--     tab_size = 18,
--     diagnostics =  "nvim_lsp" ,
--     diagnostics_update_in_insert = false,
--     diagnostics_indicator = function(count, level, diagnostics_dict, context)
--       return "("..count..")"
--     end,
--     -- NOTE: this will be called a lot so don't do any heavy processing here
--     -- custom_filter = function(buf_number, buf_numbers)
--     --   -- filter out filetypes you don't want to see
--     --   if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
--     --     return true
--     --   end
--     --   -- filter out by buffer name
--     --   if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
--     --     return true
--     --   end
--     --   -- filter out based on arbitrary rules
--     --   -- e.g. filter out vim wiki buffer from tabline in your work repo
--     --   if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
--     --     return true
--     --   end
--     --   -- filter out y it's index number in list (don't show first buffer)
--     --   if buf_numbers[1] ~= buf_number then
--     --     return true
--     --   end
--     -- end,
--     offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left" }},
--     show_buffer_icons = true , -- disable filetype icons for buffers
--     show_buffer_close_icons = false,
--     show_close_icon = false,
--     show_tab_indicators = true ,
--     persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
--     -- can also be a table containing 2 custom separators
--     -- [focused and unfocused]. eg: { '|', '|' }
--     separator_style =  { 'any', 'any' },
--     enforce_regular_tabs = false ,
--     always_show_bufferline = true ,
--     sort_by = 'ordinal'       -- add custom logic
--   }
-- }

-- Set barbar's options
require'bufferline'.setup {
  -- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  exclude_ft = {'javascript'},
  exclude_name = {'package.json'},

  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = true,

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil,
}

 local db = require('dashboard')
 db.custom_header = 
 {
    '',
    '',
    '        ⢀⣴⡾⠃⠄⠄⠄⠄⠄⠈⠺⠟⠛⠛⠛⠛⠻⢿⣿⣿⣿⣿⣶⣤⡀  ',
    '      ⢀⣴⣿⡿⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⣸⣿⣿⣿⣿⣿⣿⣿⣷ ',
    '     ⣴⣿⡿⡟⡼⢹⣷⢲⡶⣖⣾⣶⢄⠄⠄⠄⠄⠄⢀⣼⣿⢿⣿⣿⣿⣿⣿⣿⣿ ',
    '    ⣾⣿⡟⣾⡸⢠⡿⢳⡿⠍⣼⣿⢏⣿⣷⢄⡀⠄⢠⣾⢻⣿⣸⣿⣿⣿⣿⣿⣿⣿ ',
    '  ⣡⣿⣿⡟⡼⡁⠁⣰⠂⡾⠉⢨⣿⠃⣿⡿⠍⣾⣟⢤⣿⢇⣿⢇⣿⣿⢿⣿⣿⣿⣿⣿ ',
    ' ⣱⣿⣿⡟⡐⣰⣧⡷⣿⣴⣧⣤⣼⣯⢸⡿⠁⣰⠟⢀⣼⠏⣲⠏⢸⣿⡟⣿⣿⣿⣿⣿⣿ ',
    ' ⣿⣿⡟⠁⠄⠟⣁⠄⢡⣿⣿⣿⣿⣿⣿⣦⣼⢟⢀⡼⠃⡹⠃⡀⢸⡿⢸⣿⣿⣿⣿⣿⡟ ',
    ' ⣿⣿⠃⠄⢀⣾⠋⠓⢰⣿⣿⣿⣿⣿⣿⠿⣿⣿⣾⣅⢔⣕⡇⡇⡼⢁⣿⣿⣿⣿⣿⣿⢣ ',
    ' ⣿⡟⠄⠄⣾⣇⠷⣢⣿⣿⣿⣿⣿⣿⣿⣭⣀⡈⠙⢿⣿⣿⡇⡧⢁⣾⣿⣿⣿⣿⣿⢏⣾ ',
    ' ⣿⡇⠄⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢻⠇⠄⠄⢿⣿⡇⢡⣾⣿⣿⣿⣿⣿⣏⣼⣿ ',
    ' ⣿⣷⢰⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⢰⣧⣀⡄⢀⠘⡿⣰⣿⣿⣿⣿⣿⣿⠟⣼⣿⣿ ',
    ' ⢹⣿⢸⣿⣿⠟⠻⢿⣿⣿⣿⣿⣿⣿⣿⣶⣭⣉⣤⣿⢈⣼⣿⣿⣿⣿⣿⣿⠏⣾⣹⣿⣿ ',
    ' ⢸⠇⡜⣿⡟⠄⠄⠄⠈⠙⣿⣿⣿⣿⣿⣿⣿⣿⠟⣱⣻⣿⣿⣿⣿⣿⠟⠁⢳⠃⣿⣿⣿ ',
    '  ⣰⡗⠹⣿⣄⠄⠄⠄⢀⣿⣿⣿⣿⣿⣿⠟⣅⣥⣿⣿⣿⣿⠿⠋  ⣾⡌⢠⣿⡿⠃ ',
    ' ⠜⠋⢠⣷⢻⣿⣿⣶⣾⣿⣿⣿⣿⠿⣛⣥⣾⣿⠿⠟⠛⠉            ',
    '',
    '',
 }
 -- db.default_executive = 'telescope'
 db.session_directory = '~/.cache/nvim/session'
 db.custom_center = {
      {icon = '  ',
      desc = 'Recently latest session                  ',
      shortcut = 'SPC sl',
      action ='SessionLoad'},
      {icon = '  ',
      desc = ' Recently opened files                   ',
      action =  'DashboardFindHistory',
      shortcut = 'SPC h '},
      {icon = '  ',
      desc = ' Find  File                              ',
      action = 'Telescope find_files find_command=rg,--hidden,--files',
      shortcut = 'SPC f '},
      {icon = '  ',
      desc =' File Browser                            ',
      action =  'Telescope file_browser',
      shortcut = 'SPC e '},
      {icon = '  ',
      desc = ' Find  word                              ',
      action = 'Telescope live_grep',
      shortcut = 'SPC s '},
      -- {icon = '  ',
      -- desc = 'Open Personal dotfiles                  ',
      -- action = 'Telescope dotfiles path=' .. home ..'/.dotfiles',
      -- shortcut = 'SPC f d'},
    }
  db.hide_statusline = false;
  db.hide_tabline = true;

-- Default options:
-- require('kanagawa').setup({
--     undercurl = true,           -- enable undercurls
--     commentStyle = "italic",
--     functionStyle = "bold",
--     keywordStyle = "italic",
--     statementStyle = "bold",
--     typeStyle = "bold",
--     variablebuiltinStyle = "italic",
--     specialReturn = true,       -- special highlight for the return keyword
--     specialException = true,    -- special highlight for exception handling keywords
--     transparent = false,        -- do not set background color
--     dimInactive = false,        -- dim inactive window `:h hl-NormalNC`
--     globalStatus = false,       -- adjust window separators highlight for laststatus=3
--     colors = {},
--     overrides = {},
-- })

-- require('winbar').setup({
--     enabled = true,
--
--     show_file_path = true,
--     show_symbols = true,
--
--     colors = {
--         path = '', -- You can customize colors like #c946fd
--         file_name = '',
--         symbols = '',
--     },
--
--     icons = {
--         file_icon_default = '',
--         seperator = '>',
--         editor_state = '●',
--         lock_icon = '',
--     },
--
--     exclude_filetype = {
--         'help',
--         'startify',
--         'dashboard',
--         'packer',
--         'neogitstatus',
--         'NvimTree',
--         'Trouble',
--         'alpha',
--         'lir',
--         'Outline',
--         'spectre_panel',
--         'toggleterm',
--         'qf',
--     }
-- })

require"fidget".setup{}


