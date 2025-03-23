-- Initialize Mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "jdtls",       -- Java
        "omnisharp",   -- C#
        "clangd",      -- C++
        "pyright",     -- Python
--        "gopls",       -- Go
        "ts_ls",    -- JavaScript/TypeScript
        "html",        -- HTML
        "cssls",       -- CSS
        "jsonls",      -- JSON
        "yamlls",      -- YAML
--        "bash-language-server",      -- Bash
        -- "marksman",    -- Markdown
        "lua_ls"       -- Lua
    }
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.pyright.setup{}
-- Servers 
local servers = {
	"omnisharp", "clangd", "pyright", "jdtls", "julials", "r_language_server", "awk_ls", "groovyls", "kotlin_language_server", "dockerls", "jqls", "ltex", "jsonls", "omnisharp", "clangd", "pyright", "gopls", "ts_ls", "html", "cssls", "jsonls", "yamlls", "bashls", "powershell_es", "marksman", "lua_ls", "rust_analyzer", "lemminx", "vimls", "grammarly", "angularls", "ansiblels", "asm_lsp", "neocmake", "azure_pipelines_ls", "nginx_language_server", "terraformls"
}

for _, server in ipairs(servers) do
    lspconfig[server].setup({
        capabilities = capabilities
    })
end
lspconfig.lua_ls.setup {
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath('config') and (vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc')) then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = 'LuaJIT'
        },
        -- Make the server aware of Neovim runtime files
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME
          }
        }
      })
    end,
    settings = {
      Lua = {}
    }
  }
