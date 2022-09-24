local config = {

  -- Set colorscheme
  colorscheme = "default_theme",

  -- set vim options here (vim.<first_key>.<second_key> =  value)
  options = {
    opt = {
      relativenumber = true, -- sets vim.opt.relativenumber
      clipboard = "",
    },
    g = {
      mapleader = " ", -- sets vim.g.mapleader
      -- ['fsharp#lsp_codelens'] = 0,
      -- ['fsharp#show_signature_on_cursor_move'] = 0,
      -- ['OmniSharp_server_use_net6'] = 1,
    },
  },

  -- Default theme configuration
  default_theme = {
    diagnostics_style = { italic = true },
    -- Modify the color table
    -- colors = {
    --   fg = "#abb2bf",
    -- },
    -- Modify the highlight groups
    highlights = function(highlights)
      local C = require "default_theme.colors"

      highlights.Normal = { fg = C.fg, bg = C.bg }
      return highlights
    end,
  },

  -- Disable AstroNvim ui features
  ui = {
    nui_input = true,
    telescope_select = true,
  },

  -- Configure plugins
  plugins = {
    -- Add plugins, the packer syntax without the "use"
    init = {
      -- You can disable default plugins as follows:
      ["karb94/neoscroll.nvim"] = { disable = true },
      ["declancm/cinnamon.nvim"] = { disable = true },
      ["max397574/better-escape.nvim"] = { disable = true },
      ["feline-nvim/feline.nvim"] = { disable = true },

      -- You can also add new plugins here as well:
      -- { "ionide/Ionide-vim" },
      { "https://tpope.io/vim/surround.git" },
      { "https://tpope.io/vim/unimpaired.git" },
      { "https://tpope.io/vim/repeat.git" },
      { "nathom/filetype.nvim" },
      -- { "OmniSharp/omnisharp-vim" },
      -- { "hrsh7th/cmp-omni" },
      -- {
      --   "ray-x/lsp_signature.nvim",
      --   event = "BufRead",
      --   config = function()
      --     require("lsp_signature").setup()
      --   end,
      -- },
    },
    -- All other entries override the setup() call for default plugins
    treesitter = {
      ensure_installed = { "lua" },
    },
    ["nvim-lsp-installer"] = {
      ensure_installed = { "sumneko_lua" },
    },
    packer = {
      compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
    },
    telescope = {
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = require("telescope.actions").close,
            ["<C-n>"] = require("telescope.actions").move_selection_next,
            ["<C-p>"] = require("telescope.actions").move_selection_previous,
          },
        },
      },
    },
    -- ['nvim-cmp'] = {
    --   sources = {
    --     { name = "omni" },
    --   },
    -- }
  },

  -- LuaSnip Options
  luasnip = {
    -- Add paths for including more VS Code style snippets in luasnip
    vscode_snippet_paths = {},
    -- Extend filetypes
    filetype_extend = {
      javascript = { "javascriptreact" },
    },
  },

  -- Modify which-key registration
  ["which-key"] = {
    -- Add bindings
    register_mappings = {
      -- first key is the mode, n == normal mode
      n = {
        -- second key is the prefix, <leader> prefixes
        ["<leader>"] = {
          -- which-key registration table for normal mode, leader prefix
          -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
          [','] = { function() require 'telescope.builtin'.find_files({ cwd = '~/.config/nvim/lua/user/' }) end,
            "Find config file" }
        },
        g = {
          h = { vim.lsp.buf.hover, "Hover symbol details" },
        },
      },
    },
  },

  -- CMP Source Priorities
  -- modify here the priorities of default cmp sources
  -- higher value == higher priority
  -- The value can also be set to a boolean for disabling default sources:
  -- false == disabled
  -- true == 1000
  cmp = {
    source_priority = {
      nvim_lsp = 1000,
      luasnip = 750,
      buffer = 500,
      path = 250,
    },
  },

  -- Extend LSP configuration
  lsp = {
    -- enable servers that you already have installed without lsp-installer
    servers = {
      -- "pyright"
    },
    -- add to the server on_attach function
    on_attach = function(client)
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
          desc = "Auto format before save",
          pattern = "<buffer>",
          callback = function() vim.lsp.buf.format() end,
        })
      end
    end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server.name].setup(opts)
    -- end

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = {
      -- example for addings schemas to yamlls
      -- yamlls = {
      --   settings = {
      --     yaml = {
      --       schemas = {
      --         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
      --         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
      --         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
      --       },
      --     },
      --   },
      -- },
    },
  },

  -- Diagnostics configuration (for vim.diagnostics.config({}))
  diagnostics = {
    virtual_text = true,
    underline = false,
  },

  -- This function is run last
  -- good place to configure mappings and vim options
  polish = function()
    -- Set key bindings
    vim.keymap.set("n", "<C-l>", ":nohl<CR>")

    local function save_buffer()
      vim.api.nvim_command("stopinsert")
      vim.api.nvim_command("w!")
    end

    vim.keymap.set("i", "<D-s>", save_buffer)
    vim.keymap.set("n", "<D-s>", save_buffer)

    vim.keymap.set("i", "<D-v>", "<C-r>+")
    vim.keymap.set("x", "<D-v>", "<C-r>+")

    vim.keymap.set("n", "<D-w>", ":Bd<CR>")
    vim.keymap.set("n", "<D-p>", function() require 'telescope.builtin'.find_files({}) end)

    vim.keymap.set("n", "[c", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]c", vim.diagnostic.goto_next)

    vim.keymap.del("t", "<esc>")
    vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")

    vim.keymap.set("n", "<D-j>", function() vim.api.nvim_command("ToggleTerm float") end)
    vim.keymap.set("t", "<D-j>", function() vim.api.nvim_command("ToggleTerm float") end)

    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", {})
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "plugins.lua",
      command = "source <afile> | PackerSync",
    })
    vim.api.nvim_create_autocmd("TextYankPost", {
      desc = "Highlight yarnked text",
      group = "packer_conf",
      callback = function() require 'vim.highlight'.on_yank { timeout = 250 } end
    })

    require 'filetype'.setup {
      overrides = {
        extensions = {
          -- Set the filetype of *.pn files to potion
          fsproj = "xml",
          fs = "fsharp",
          fsx = "fsharp",
          fsi = "fsharp",
        },
      }
    }

    -- require'cmp'.setup {
    --   sources = {
    --     { name = 'omni' }
    --   }
    -- }

    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
  end,
}

return config
