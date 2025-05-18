vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("monologique-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

---@type vim.diagnostic.Opts
local diagnostic_config = {
	virtual_text = true,
}

vim.diagnostic.config(diagnostic_config)

---@diagnostic disable: missing-fields
require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

vim.lsp.enable({ "lua_ls", "nixd", "taplo" })

require("mini.snippets").setup()
local cmp = require("cmp")
cmp.setup({
	completion = {
		autocomplete = false,
	},
	performance = {
		max_view_entries = 8,
	},
	snippet = {
		expand = function(args)
			local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
			insert({ body = args.body })
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		-- ["<Tab>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "lazydev", group_index = 0 },
	}, {
		{ name = "buffer" },
	}),
})

require("nvim-treesitter.configs").setup({
	hightlight = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,

			lookahead = true,

			keymaps = {
				["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
				["if"] = { query = "@function.inner", desc = "Select inter part of a function region" },
				["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
			},
		},
	},
})

require("which-key").setup()
