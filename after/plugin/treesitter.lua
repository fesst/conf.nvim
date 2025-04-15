require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
    ensure_installed = {
        "lua", "python", "kotlin", "java", "scala", "groovy",
        "c_sharp", "c", "cpp", "make", "cmake", "powershell", "awk", "asm",
        "go", "dockerfile", "bash", "sql", "awk", "diff", "gitignore",
        "javascript", "typescript", "html", "scss", "css", "json", "yaml", "vue", "angular", "graphql", "svelte",
        "query", "haskell", "ocaml", "scheme", "clojure", "fennel", "racket", "commonlisp",
        "rust", "php", "perl", "ruby", "pascal", "htmldjango", "llvm", "luadoc",
        "nginx", "fsharp", "git_config", "git_rebase", "glsl", "jq", "passwd",
        "clojure","toml", "elixir", "erlang", "fsharp", "csv",
        "swift", "dart",
        "vim", "vimdoc", "regex", "xml", "markdown", "markdown_inline", "latex", "r", "julia",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}
