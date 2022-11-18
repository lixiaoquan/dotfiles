if !exists('g:loaded_nvim_treesitter')
  echom "Not loaded treesitter"
  finish
endif

lua << EOF

-- for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
--  config.install_info.url = config.install_info.url:gsub("https://github.com/", "https://hub.gitfast.tk/")
-- end

require'nvim-treesitter.install'.prefer_git = true

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      scope_incremental = "<TAB>",
      node_decremental = "<BS>",
    },
  },
  indent = {
    enable = false,
    disable = {},
  },
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["<leader>xp"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>xP"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["<leader>j"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["<leader>k"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}
EOF
