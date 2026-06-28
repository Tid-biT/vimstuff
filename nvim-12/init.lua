vim.opt.runtimepath:append("/home/ted/projects/aider/neovim/runtime")
vim.g.sqlite_clib_path = "/usr/lib/x86_64-linux-gnu/libsqlite3.so.0.8.6"
vim.opt.updatetime = 3000  -- milliseconds of idle time before completion triggers

-- Set the leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
      { "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Search Buffers" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search Help" },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
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
			keymap = { preset = "default" },
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = {
          auto_show = true,
          auto_show_delay_ms = 5000,
        },
        trigger = {
          show_on_keyword = true,
        },
        menu = {
          auto_show = true,
          auto_show_delay_ms = 3000,
        },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
				providers = {
					codecompanion = {
						name = "CodeCompanion",
						module = "codecompanion.providers.completion.blink",
						enabled = true,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
})

vim.lsp.enable("clangd")
