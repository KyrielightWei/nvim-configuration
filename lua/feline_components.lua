local lsp = require 'feline.providers.lsp'
local vi_mode_utils = require 'feline.providers.vi_mode'

local lsp_get_diag = function(str)
  -- local count = vim.lsp.diagnostic.get_count(0, str)
  local count = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.str})
  return (count > 0) and ' '..count..' ' or ''
end

local gps = require("nvim-gps")

local colors = {
    bg = '#282c34',
    fg = '#abb2bf',
    yellow = '#e0af68',
    cyan = '#56b6c2',
    darkblue = '#081633',
    green = '#98c379',
    orange = '#d19a66',
    violet = '#a9a1e1',
    magenta = '#c678dd',
    blue = '#61afef',
    red = '#e86671'
}

local vi_mode_colors = {
    NORMAL = colors.green,
    INSERT = colors.red,
    VISUAL = colors.magenta,
    OP = colors.green,
    BLOCK = colors.blue,
    REPLACE = colors.violet,
    ['V-REPLACE'] = colors.violet,
    ENTER = colors.cyan,
    MORE = colors.cyan,
    SELECT = colors.orange,
    COMMAND = colors.green,
    SHELL = colors.green,
    TERM = colors.green,
    NONE = colors.yellow
}

local function file_osinfo()
    local os = vim.bo.fileformat:upper()
    local icon
    if os == 'UNIX' then
        icon = ' '
    elseif os == 'MAC' then
        icon = ' '
    else
        icon = ' '
    end
    return icon .. os
end

local file_info_comps = {

    provider = {
      name = 'file_info',
      opts = {
        type = 'relative',
        -- file_readonly_icon = '  ',
        file_readonly_icon = '  ',
        -- file_readonly_icon = '  ',
        -- file_readonly_icon = '  ',
        -- file_modified_icon = '',
        -- file_modified_icon = '',
        -- file_modified_icon = 'ﱐ',
        -- file_modified_icon = '',
        -- file_modified_icon = '',
        file_modified_icon = '',
      }
    },
    hl = {
        fg = colors.blue,
        style = 'bold'
    }
}

local vim_mode_comps = {

    provider = function()
      return '  ' .. vi_mode_utils.get_vim_mode()
    end,
    hl = function()
        local val = {
            name = vi_mode_utils.get_mode_highlight_name(),
            fg = vi_mode_utils.get_mode_color(),
            -- fg = colors.bg
        }
        return val
    end,
    right_sep = ' '
}

local M = {
    statusline = {
        icons = {
            active = {},
            inactive = {},
        },
        noicons = {
            active = {},
            inactive = {},
        },
    },
    winbar = {
        icons = {
            active = {},
            inactive = {},
        },
        noicons = {
            active = {},
            inactive = {},
        },
    },
}

M.statusline.icons.active[1] = {
    [1] = {
        provider = '▊ ',
        hl = {
            fg = 'skyblue',
        },
    },
    -- {
        -- provider = 'vi_mode',
        -- hl = function()
        --     return {
        --         name = vi_mode_utils.get_mode_highlight_name(),
        --         fg = vi_mode_utils.get_mode_color(),
        --         style = 'bold',
        --     }
        -- end,
        [2] = vim_mode_comps
    -- }
    ,
    -- {
        [3] = file_info_comps
    -- }
    ,
    [4] = {
      
        provider = 'file_encoding',
        left_sep = ' ',
        hl = {
            fg = colors.violet,
            style = 'bold'
        }
    },
    [5] = {
        provider = 'file_size',
        right_sep = {
            ' ',
        },
        left_sep = ' ',
    },
}

M.statusline.icons.active[2] = {
    {
        provider = function()
            return '' .. lsp_get_diag("ERROR")
        end,
        -- left_sep = ' ',
        enabled = function() return lsp.diagnostics_exist('ERROR') end,
        hl = {
            fg = colors.red
        }
    },
    {
        -- provider = 'diagnostic_warnings',
        provider = function()
            return '' ..  lsp_get_diag("WARN")
        end,
        -- left_sep = ' ',
        enabled = function() return lsp.diagnostics_exist('WARN') end,
        hl = {
            fg = colors.yellow
        }
    },
    {
        -- provider = 'diagnostic_info',
        provider = function()
            return '' .. lsp_get_diag("INFO")
        end,
        -- left_sep = ' ',
        enabled = function() return lsp.diagnostics_exist('INFO') end,
        hl = {
            fg = colors.blue
        }
    },
    {
        -- provider = 'diagnostic_hints',
        provider = function()
            return '' .. lsp_get_diag("HINT")
        end,
        -- left_sep = ' ',
        enabled = function() return lsp.diagnostics_exist('HINT') end,
        hl = {
            fg = colors.cyan
        }
    },
    {
        provider = file_osinfo,
        left_sep = ' ',
        hl = {
            fg = colors.violet,
            style = 'bold'
        }
    },
    {
        provider = 'position',
        left_sep = ' ',
        hl = {
            fg = colors.cyan,
            -- style = 'bold'
        }
    },
    {
        provider = 'git_branch',
        icon = ' ',
        -- icon = ' ',
        left_sep = ' ',
        hl = {
            fg = colors.violet,
            style = 'bold'
        },
    },
    {
        provider = 'git_diff_added',
        hl = {
            fg = colors.green
        },
    },
    {
        provider = 'git_diff_changed',
        hl = {
            fg = colors.orange
        },
    },
    {
        provider = 'git_diff_removed',
        hl = {
            fg = colors.red
        },
        -- right_sep = {
        --     str = ' ',
        --     hl = {
        --         fg = 'NONE',
        --         bg = 'black',
        --     },
        -- },
    },
    {
        provider = 'line_percentage',
        hl = {
            style = 'bold',
        },
        left_sep = '  ',
        right_sep = ' ',
    },
    {
        provider = 'scroll_bar',
        hl = {
            fg = 'skyblue',
            style = 'bold',
        },
    },
}

M.statusline.icons.inactive[1] = {
    -- {
    [1] =  file_info_comps
    -- }
    ,
    -- {
    [2] =  vim_mode_comps
    -- }
    ,
    -- Empty component to fix the highlight till the end of the statusline
    [3] = {},
}

M.statusline.noicons.active[1] = {
    {
        provider = '▊ ',
        hl = {
            fg = 'skyblue',
        },
    },
    {
        provider = 'vi_mode',
        hl = function()
            return {
                name = vi_mode_utils.get_mode_highlight_name(),
                fg = vi_mode_utils.get_mode_color(),
                style = 'bold',
            }
        end,
        right_sep = ' ',
        icon = '',
    },
    {
        provider = 'file_info',
        hl = {
            fg = 'white',
            bg = 'oceanblue',
            style = 'bold',
        },
        left_sep = '',
        right_sep = {
            {
                str = ' ',
                hl = {
                    fg = 'NONE',
                    bg = 'oceanblue',
                },
            },
            ' ',
        },
        icon = '',
    },
    {
        provider = 'file_size',
        right_sep = {
            ' ',
            {
                str = 'vertical_bar_thin',
                hl = {
                    fg = 'fg',
                    bg = 'bg',
                },
            },
        },
    },
    {
        provider = 'position',
        left_sep = ' ',
        right_sep = {
            ' ',
            {
                str = 'vertical_bar_thin',
                hl = {
                    fg = 'fg',
                    bg = 'bg',
                },
            },
        },
    },
    {
        provider = 'diagnostic_errors',
        hl = { fg = 'red' },
        icon = ' E-',
    },
    {
        provider = 'diagnostic_warnings',
        hl = { fg = 'yellow' },
        icon = ' W-',
    },
    {
        provider = 'diagnostic_hints',
        hl = { fg = 'cyan' },
        icon = ' H-',
    },
    {
        provider = 'diagnostic_info',
        hl = { fg = 'skyblue' },
        icon = ' I-',
    },
}

M.statusline.noicons.active[2] = {
    {
        provider = 'git_branch',
        hl = {
            fg = 'white',
            bg = 'black',
            style = 'bold',
        },
        right_sep = {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = 'black',
            },
        },
        icon = ' ',
    },
    {
        provider = 'git_diff_added',
        hl = {
            fg = 'green',
            bg = 'black',
        },
        icon = ' +',
    },
    {
        provider = 'git_diff_changed',
        hl = {
            fg = 'orange',
            bg = 'black',
        },
        icon = ' ~',
    },
    {
        provider = 'git_diff_removed',
        hl = {
            fg = 'red',
            bg = 'black',
        },
        right_sep = {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = 'black',
            },
        },
        icon = ' -',
    },
    {
        provider = 'line_percentage',
        hl = {
            style = 'bold',
        },
        left_sep = '  ',
        right_sep = ' ',
    },
    {
        provider = 'scroll_bar',
        hl = {
            fg = 'skyblue',
            style = 'bold',
        },
    },
}

M.statusline.noicons.inactive[1] = {
    {
        provider = 'file_type',
        hl = {
            fg = 'white',
            bg = 'oceanblue',
            style = 'bold',
        },
        left_sep = {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = 'oceanblue',
            },
        },
        right_sep = {
            {
                str = ' ',
                hl = {
                    fg = 'NONE',
                    bg = 'oceanblue',
                },
            },
            ' ',
        },
    },
    -- Empty component to fix the highlight till the end of the statusline
    {},
}

M.winbar.icons.active[1] = {
    -- {
    --     provider = 'file_info',
    --     hl = {
    --         fg = 'skyblue',
    --         bg = 'NONE',
    --         style = 'bold',
    --     },
    -- },
    {
      provider = function()
        return gps.get_location()
      end,
      enabled = function()
        return gps.is_available()
      end,
        hl = {
            fg = colors.yellow,
            bg = 'NONE',
            style = 'bold',
        },
    },
}

M.winbar.icons.inactive[1] = {
    {
        provider = 'file_info',
        hl = {
          colors.blue,
        },
    },
}

M.winbar.noicons.active[1] = {
    {
        provider = 'file_info',
        hl = {
            fg = 'skyblue',
            bg = 'NONE',
            style = 'bold',
        },
        icon = '',
    },
}

M.winbar.noicons.inactive[1] = {
    {
        provider = 'file_info',
        hl = {
            fg = 'white',
            bg = 'NONE',
            style = 'bold',
        },
        icon = '',
    },
}


require('feline').setup{
    colors = { bg = colors.bg, fg = colors.fg },
    vi_mode_colors = vi_mode_colors,
    components = M.statusline.icons,
}

require('feline').winbar.setup
{
  colors = { bg = colors.bg, fg = colors.fg },
  components = M.winbar.icons;
}

