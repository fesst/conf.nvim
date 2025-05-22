-- Base folding configuration
local function setup_base_folding()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldenable = true
    vim.opt_local.foldcolumn = "4"
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldminlines = 1
    vim.opt_local.foldnestmax = 20
end

-- Set up Python folding with indent-based method
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile", "FileType"}, {
    pattern = { "*.py", "python" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldmethod = "indent"
        vim.opt_local.foldexpr = ""  -- Clear any expr-based folding
    end,
    group = vim.api.nvim_create_augroup("PythonFolding", { clear = true }),
})

-- Set up Lua folding
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile", "FileType"}, {
    pattern = { "*.lua", "lua" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("LuaFolding", { clear = true }),
})

-- Set up Shell script folding
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile", "FileType"}, {
    pattern = { "*.sh", "*.bash", "*.zsh", "sh", "bash", "zsh" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldmethod = "indent"
        vim.opt_local.foldexpr = ""  -- Clear any expr-based folding
    end,
    group = vim.api.nvim_create_augroup("ShellFolding", { clear = true }),
})

-- Set up C/C++ folding
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "cuda" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("CCPPFolding", { clear = true }),
})

-- Set up JavaScript/TypeScript folding
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("JSTSFolding", { clear = true }),
})

-- Set up JSON folding
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "jsonc" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("JSONFolding", { clear = true }),
})

-- Set up HTML folding
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "htmldjango" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("HTMLFolding", { clear = true }),
})

-- Set up CSS folding
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "css", "scss", "less" },
    callback = function()
        setup_base_folding()
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("CSSFolding", { clear = true }),
})

-- Set up default folding for all other file types
vim.api.nvim_create_autocmd({"BufReadPost", "BufNewFile", "FileType"}, {
    pattern = { "*" },
    callback = function()
        -- Skip files that have specific folding configurations
        local skip_filetypes = {
            python = true,
            lua = true,
            sh = true,
            bash = true,
            zsh = true,
            c = true,
            cpp = true,
            objc = true,
            cuda = true,
            javascript = true,
            typescript = true,
            javascriptreact = true,
            typescriptreact = true,
            json = true,
            jsonc = true,
            html = true,
            htmldjango = true,
            css = true,
            scss = true,
            less = true,
        }
        
        if skip_filetypes[vim.bo.filetype] then
            return
        end
        
        setup_base_folding()
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    end,
    group = vim.api.nvim_create_augroup("DefaultFolding", { clear = true }),
})

-- Treesitter configuration
require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = {
        "lua",
        "python",
        "kotlin",
        "java",
        "scala",
        "c_sharp",
        "c",
        "cpp",
        "make",
        "cmake",
        "powershell",
        "awk",
        "asm",
        "go",
        "bash",
        "sql",
        "diff",
        "gitignore",
        "javascript",
        "typescript",
        "html",
        "scss",
        "css",
        "json",
        "yaml",
        "graphql",
        "query",
        "haskell",
        "ocaml",
        "scheme",
        "clojure",
        "racket",
        "commonlisp",
        "rust",
        "php",
        "perl",
        "ruby",
        "pascal",
        "htmldjango",
        "llvm",
        "luadoc",
        "nginx",
        "fsharp",
        "git_config",
        "git_rebase",
        "glsl",
        "jq",
        "passwd",
        "toml",
        "elixir",
        "erlang",
        "csv",
        "swift",
        "dart",
        "vim",
        "vimdoc",
        "regex",
        "xml",
        "markdown",
        "markdown_inline",
        "r",
        "julia",
        -- Previously disabled parsers, now enabled
        "angular",
        "dockerfile",
        "fennel",
        "groovy",
        "latex",
        "svelte",
        "vue",
        -- C/C++ related parsers
        "cuda",
        "objc",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    -- Required fields
    modules = {},
    ignore_install = {},

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },

    -- Add incremental selection
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },

    -- Add indentation
    indent = {
        enable = true,
    },

    -- Add text objects
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
    },

    -- Add folding
    fold = {
        enable = true,
        disable = {},
    },
})
