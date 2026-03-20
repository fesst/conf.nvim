local ssh_utils = require("motleyfesst.utils.ssh")
if not ssh_utils.IS_LOCAL() then
    return
end

-- ============================================================
-- blink.cmp setup (old nvim-cmp config in after/discharged/completion/)
-- blink.compat is a dependency that shims the nvim-cmp API,
-- so the custom Bazel source in bzl.lua (register_source) still works.
-- ============================================================
local blink = require("blink.cmp")
local lspkind = require("lspkind")

local kind_icon_component = {
    kind_icon = {
        text = function(ctx)
            return lspkind.symbolic(ctx.kind, { mode = "symbol" }) or ctx.kind_icon .. " "
        end,
        highlight = function(ctx)
            return "CmpItemKind" .. ctx.kind
        end,
    },
}

blink.setup({
    keymap = {
        preset = "none",
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        -- <C-Space> and <C-@> are the same key in some terminals
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-@>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
        menu = {
            border = "rounded",
            draw = {
                components = kind_icon_component,
            },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 400,
            window = { border = "rounded" },
        },
    },
    sources = {
        default = { "lsp", "path", "buffer", "bazel" },
        providers = {
            -- bazel source is the custom one from bzl.lua, bridged via blink.compat
            bazel = {
                name = "bazel",
                module = "blink.compat.source",
                score_offset = -3,
                opts = {},
            },
        },
    },
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
    },
})
