vim.opt.runtimepath:append("/home/ted/projects/aider/neovim/runtime")
vim.g.sqlite_clib_path = "/usr/lib/x86_64-linux-gnu/libsqlite3.so.0.8.6"

--vim.opt.updatetime = 2000  -- milliseconds of idle time before completion triggers

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

vim.opt.cursorline = true
vim.opt.scrolloff = 8

vim.opt.showtabline = 0
vim.opt.number = true
vim.opt.relativenumber = true

-- Set the leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.autoformat = false

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- Make sure it loads immediately on startup
    priority = 1000, -- Load this before all other plugins
    opts = {
      style = "night",
      -- Custom highlight modifications go here
      on_highlights = function(hl, c)
        local darker_bg = "#16161c"
        hl.CursorLine = { 
          bg = darker_bg
        }
        hl.CursorLineNr = { 
          fg = c.orange, 
          bg = darker_bg
        }
      end,
    },
    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your custom specs or override configurations if any
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (Which-key)",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master", -- or tag = '0.1.8'
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Alternative)" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Search by Grep" },
      { "<leader>sw", "<cmd>Telescope grep_string word_match=-w<cr>", desc = "Search Word under cursor" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "LSP Document Symbols" },
      { "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "LSP Workspace Symbols" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search Help" },
      { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Search Buffers" },
      { "<leader>r", "<cmd>Telescope oldfiles<cr>", desc = "Search old files" },
    },
    opts = {
      defaults = {
        sorting_strategy = "ascending", 
        layout_config = {
          prompt_position = "top",
        },
        -- Tells Telescope to drop any result matching these system path patterns
        file_ignore_patterns = {
          "^/usr/",              -- Blocks standard Linux system headers
          "^/usr/include/",      -- Blocks C/C++ STL headers
          "%.tcc",               -- Blocks internal GCC template implementation files
          -- Add your toolchain/SDK path here if you use an isolated compiler toolchain
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-f>"] = function(prompt_bufnr)
                require("telescope.actions").to_fuzzy_refine(prompt_bufnr)
            end,
          },
        },
      },
    },
    pickers = {
      buffers = {
        show_all_buffers = false,
        sort_mru = true,
        ignore_current_buffer = true,
      },
    },
  },
  {
    "kkharji/sqlite.lua",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "kkharji/sqlite.lua",
      "ravitemer/codecompanion-history.nvim",  -- correct repo
    },
    config = function()
      require("codecompanion").setup({
        adapters = {
          http = {
            anthropic = function()
              return require("codecompanion.adapters").extend("anthropic", {
                env = { api_key = "ANTHROPIC_API_KEY" },
              })
            end,
            llama_cpp = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  url = "http://localhost:8080",
                },
                schema = {
                  model = {
                    default = "local-model",
                  },
                },
              })
            end,
          },
        },
        interactions = {
          chat   = { adapter = "llama_cpp" },
          inline = { adapter = "llama_cpp" },
          agent  = { adapter = "llama_cpp" },
        },
        extensions = {
          history = {
            enabled = true,
            opts = {
              auto_save = true,
              expiration_days = 30,
              picker = "default",
            },
          },
        },
      })
    end,
  },
  {
      "neovim/nvim-lspconfig",
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
        keymap = { 
            preset = "default",
            -- 1. Use Ctrl+Y to manually invoke the combined text and symbol list
            ["<C-y>"] = { "show", "accept", "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 5000,
            },
            trigger = {
                show_on_keyword = false,
                show_on_trigger_character = false,
            },
            menu = {
                auto_show = true,
                auto_show_delay_ms = 3000,
            },
        },
        sources = {
            default = { "buffer", "lsp", "path", "snippets" },
            per_filetype = {
                codecompanion = { "codecompanion" },
            },
            providers = {
                codecompanion = {
                    name = "CodeCompanion",
                    module = "codecompanion.providers.completion.blink",
                    enabled = true,
                },
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",
                    fallbacks = {}, -- Keeps buffer words visible alongside LSP symbols
                },
                buffer = {
                    score_offset = 100, -- Keeps buffer words sorted at the top
                },
            },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },

})

vim.lsp.enable("clangd")

--vim.opt.autocomplete = false
-- current buffer text (.), other open windows (w), background buffers (b), and LSP completion definitions (o) into one list
--vim.opt.complete = { ".","w","b","o" }
--vim.opt.completeopt = { "menuone", "noselect", "noinsert", "fuzzy" }
