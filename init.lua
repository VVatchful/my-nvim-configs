-- init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Global function for safe requiring of modules
_G.safe_require = function(module)
  local status_ok, loaded_module = pcall(require, module)
  if not status_ok then
    vim.notify("Failed to load " .. module, vim.log.levels.ERROR)
    return nil
  end
  return loaded_module
end

-- Initialize lazy.nvim with protected call
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

-- Plugin specifications
local plugins = {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },

  -- Git integration
  "lewis6991/gitsigns.nvim",

  -- Theme
  { "catppuccin/nvim", name = "catppuccin" },
  -- Add monochrome.nvim colorscheme
  {"darkvoid-theme/darkvoid.nvim", name = "darkvoid" },
  {
        'xero/miasma.nvim',
        config = function()
            -- Apply the colorscheme after the plugin is loaded
            vim.cmd([[colorscheme miasma]])
        end
  },
  {
    'rockerBOO/boo-colorscheme-nvim',
    config = function()
          vim.cmd([[colorscheme boo]])
    end
  },

  -- Autopairs
  "windwp/nvim-autopairs",

  -- Comments
  "numToStr/Comment.nvim",

  -- Indent guides
  "lukas-reineke/indent-blankline.nvim",

  -- Which-key for keybinding help
  "folke/which-key.nvim",

  -- Faster file navigation
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- Faster code navigation
  {
    "phaazon/hop.nvim",
    branch = "v2",
  },

  -- Faster surround operations
  "kylechui/nvim-surround",

  -- Faster project management
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {}
    end
  },

  -- Faster terminal integration
  { "akinsho/toggleterm.nvim", version = "*", config = true },

  -- Faster debugging
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
  },

  -- Faster startup
  "lewis6991/impatient.nvim",

  -- Faster code formatting
  "mhartington/formatter.nvim",
}

-- Initialize lazy.nvim
lazy.setup(plugins)

-- Enable impatient for faster startup
safe_require('impatient')

-- Basic settings
local set = vim.opt

set.number = true                -- Show line numbers
set.relativenumber = true        -- Show relative line numbers
set.cursorline = true            -- Highlight the current line
set.mouse = 'a'                  -- Enable mouse support
set.clipboard = 'unnamedplus'    -- Use system clipboard
set.expandtab = true             -- Use spaces instead of tabs
set.tabstop = 2                 -- Number of spaces tabs count for
set.shiftwidth = 4               -- Size of an indent
set.softtabstop = 4              -- Number of spaces in tab when editing
set.smartindent = true           -- Insert indents automatically
set.wrap = false                 -- Don't wrap lines
set.ignorecase = true            -- Ignore case in search patterns
set.smartcase = true             -- Override ignorecase if search pattern contains upper case characters
set.hlsearch = false             -- Don't highlight all matches on previous search pattern
set.incsearch = true             -- Show matches while typing search pattern
set.hidden = true                -- Enable background buffers
set.history = 100                -- Remember N lines in history
set.lazyredraw = true            -- Faster scrolling
set.synmaxcol = 240              -- Max column for syntax highlight
set.updatetime = 250             -- Faster completion
set.timeoutlen = 300             -- Faster key sequence completion
set.splitright = true            -- Vertical splits to the right
set.splitbelow = true            -- Horizontal splits below
set.scrolloff = 8                -- Lines of context
set.sidescrolloff = 8            -- Columns of context
set.cmdheight = 2                -- More space for displaying messages
set.pumheight = 10               -- Max items to show in pop up menu
set.conceallevel = 0             -- Show `` in markdown files
set.showmode = false             -- Don't show mode (lualine will do that)
set.backup = false               -- Don't make a backup before overwriting a file
set.writebackup = false          -- Don't make a backup before overwriting a file
set.swapfile = false             -- Don't use swapfile
set.undofile = true              -- Enable persistent undo
set.colorcolumn = "150"           -- Line length marker at 150 columns
set.signcolumn = "yes"           -- Always show the signcolumn
set.fillchars = { eob = " " }    -- Remove ~ from end of buffer
set.termguicolors = true         -- True color support
set.list = true                  -- Show some invisible characters
set.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Set colorscheme
vim.cmd[[colorscheme darkvoid]]

-- LSP configuration
local mason = safe_require("mason")
local mason_lspconfig = safe_require("mason-lspconfig")
local lspconfig = safe_require("lspconfig")

if mason and mason_lspconfig and lspconfig then
  mason.setup()
  mason_lspconfig.setup()

  mason_lspconfig.setup_handlers({
    function(server_name)
      lspconfig[server_name].setup{}
    end,
  })
end

-- Autocompletion setup
local cmp = safe_require('cmp')
local luasnip = safe_require('luasnip')

if cmp and luasnip then
  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
      { name = 'path' },
    })
  })
end

-- Treesitter configuration
local treesitter = safe_require('nvim-treesitter.configs')
if treesitter then
  treesitter.setup {
    ensure_installed = "all",
    highlight = {
      enable = true,
    },
    indent = { enable = true },
  }
end

-- Telescope configuration
local telescope = safe_require('telescope')
if telescope then
  telescope.setup{
    defaults = {
      prompt_prefix = ' >',
      color_devicons = true,
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    -- You can keep other extensions or configurations here if needed
  }
  telescope.load_extension('projects')
end

-- Neo-tree configuration
local neotree = safe_require("neo-tree")
if neotree then
  neotree.setup()
end

-- Lualine configuration
local lualine = safe_require('lualine')
if lualine then
  lualine.setup{
    options = {
      theme = 'catppuccin'
    }
  }
end

-- Gitsigns configuration
local gitsigns = safe_require('gitsigns')
if gitsigns then
  gitsigns.setup()
end

-- Autopairs configuration
local autopairs = safe_require('nvim-autopairs')
if autopairs then
  autopairs.setup{}
end

-- Comment.nvim configuration
local comment = safe_require('Comment')
if comment then
  comment.setup()
end

-- Which-key configuration
local which_key = safe_require('which-key')
if which_key then
  which_key.setup{}
end

-- Harpoon setup
local mark = safe_require("harpoon.mark")
local ui = safe_require("harpoon.ui")

-- Hop setup
local hop = safe_require('hop')
if hop then
  hop.setup()
end

-- Nvim-surround setup
local nvim_surround = safe_require("nvim-surround")
if nvim_surround then
  nvim_surround.setup()
end

-- ToggleTerm setup
local toggleterm = safe_require("toggleterm")
if toggleterm then
  toggleterm.setup{
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    start_in_insert = true,
    persist_size = true,
    direction = 'float',
  }
end


-- Formatter setup
local formatter = safe_require('formatter')
if formatter then
  formatter.setup({
    filetype = {
      javascript = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), '--single-quote'},
            stdin = true
          }
        end
      },
      -- Add more filetypes as needed
    }
  })
end

-- Key mappings
local opts = { noremap = true, silent = true }

-- Set leader key to space
vim.g.mapleader = " "

-- LSP mappings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

-- Telescope mappings
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', opts)
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', opts)
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', opts)

-- Neo-tree mapping
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', opts)

-- Harpoon mappings
vim.keymap.set('n', '<leader>a', function() mark.add_file() end, opts)
vim.keymap.set('n', '<C-e>', function() ui.toggle_quick_menu() end, opts)
vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end, opts)
vim.keymap.set('n', '<C-j>', function() ui.nav_file(2) end, opts)
vim.keymap.set('n', '<C-k>', function() ui.nav_file(3) end, opts)
vim.keymap.set('n', '<C-l>', function() ui.nav_file(4) end, opts)

-- Hop mappings
vim.keymap.set('n', 'f', ':HopChar1<CR>', opts)
vim.keymap.set('n', 'F', ':HopWord<CR>', opts)

-- Telescope project mapping
vim.keymap.set('n', '<leader>fp', ':Telescope projects<CR>', opts)

-- Debugging mappings
vim.keymap.set('n', '<leader>db', function() require"dap".toggle_breakpoint() end, opts)
vim.keymap.set('n', '<leader>dc', function() require"dap".continue() end, opts)
vim.keymap.set('n', '<leader>dt', function() require"dapui".toggle() end, opts)

-- Formatting mapping
vim.keymap.set('n', '<leader>f', ':Format<CR>', opts)

-- Buffer navigation
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', opts)
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', opts)

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- Resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Move text up and down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', opts)
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", opts)

-- Indenting
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Comments
vim.keymap.set('n', '<leader>/', ':lua require("Comment.api").toggle.linewise.current()<CR>', opts)
vim.keymap.set('x', '<leader>/', '<ESC>:lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts)

-- Terminal mappings
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = '1000' })
  end
})

-- Remove whitespace on save
autocmd('BufWritePre', {
  pattern = '',
  command = ":%s/\\s\\+$//e"
})

-- Don't auto commenting new lines
autocmd('BufEnter', {
  pattern = '',
  command = 'set fo-=c fo-=r fo-=o'
})

-- Settings for filetypes:
-- Disable line length marker
augroup('setLineLength', { clear = true })
autocmd('Filetype', {
  group = 'setLineLength',
  pattern = { 'text', 'markdown', 'html', 'xhtml', 'javascript', 'typescript' },
  command = 'setlocal cc=0'
})

-- Set indentation to 2 spaces
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
    'yaml', 'lua'
  },
  command = 'setlocal shiftwidth=2 tabstop=2'
})

-- Terminal settings:
-- Open a Terminal on the right tab
autocmd('CmdlineEnter', {
  command = 'command! Term :botright vsplit term://$SHELL'
})

-- Enter insert mode when switching to terminal
autocmd('TermOpen', {
  command = 'setlocal listchars= nonumber norelativenumber nocursorline',
})

autocmd('TermOpen', {
  pattern = '',
  command = 'startinsert'
})

-- Close terminal buffer on process exit
autocmd('BufLeave', {
  pattern = 'term://*',
  command = 'stopinsert'
})

-- Formatting
-- Format on save
autocmd('BufWritePre', {
  pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
  command = 'Format'
})
