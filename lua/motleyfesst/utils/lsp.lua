local M = {}

local LOG_TAG = "[lsp_utils]"

local function format_buffer(bufnr)
    require("conform").format({ bufnr = bufnr, timeout_ms = 3000, lsp_format = "fallback" })
end

local function telescope_or_lsp(telescope_picker, fallback)
    return function()
        local builtin = require("telescope.builtin")
        if builtin[telescope_picker] then
            builtin[telescope_picker]()
            return
        end
        fallback()
    end
end

local function workspace_symbols()
    local query = vim.fn.input("Workspace symbol > ")
    if query == nil then
        return
    end

    local builtin = require("telescope.builtin")
    if builtin.lsp_workspace_symbols then
        builtin.lsp_workspace_symbols({ query = query })
        return
    end

    vim.lsp.buf.workspace_symbol(query)
end

local function list_workspace_folders()
    local folders = vim.lsp.buf.list_workspace_folders()
    if vim.tbl_isempty(folders) then
        vim.notify(LOG_TAG .. " no workspace folders", vim.log.levels.INFO)
        return
    end
    vim.notify(table.concat(folders, "\n"), vim.log.levels.INFO)
end

local function toggle_inlay_hints(bufnr)
    if not vim.lsp.inlay_hint or not vim.lsp.inlay_hint.enable then
        vim.notify(LOG_TAG .. " inlay hints are not supported by this Neovim build", vim.log.levels.WARN)
        return
    end

    local enabled = vim.b[bufnr].lsp_inlay_hints_enabled or false
    if type(vim.lsp.inlay_hint.is_enabled) == "function" then
        local ok_new_api, is_enabled = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
        if ok_new_api then
            enabled = is_enabled
        else
            local ok_old_api, old_enabled = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
            if ok_old_api then
                enabled = old_enabled
            end
        end
    end

    local next_state = not enabled
    local ok_new_api = pcall(vim.lsp.inlay_hint.enable, next_state, { bufnr = bufnr })
    if not ok_new_api then
        local ok_old_api = pcall(vim.lsp.inlay_hint.enable, bufnr, next_state)
        if not ok_old_api then
            vim.notify(LOG_TAG .. " failed to toggle inlay hints", vim.log.levels.WARN)
            return
        end
    end

    vim.b[bufnr].lsp_inlay_hints_enabled = next_state
end

local function refresh_codelens(bufnr)
    if not vim.lsp.codelens or not vim.lsp.codelens.refresh or not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    local ok_new_api = pcall(vim.lsp.codelens.refresh, { bufnr = bufnr })
    if not ok_new_api then
        pcall(vim.lsp.codelens.refresh)
    end
end

local function open_diagnostic_quickfix()
    vim.diagnostic.setqflist()
    vim.cmd("copen")
end

local function open_diagnostic_loclist()
    vim.diagnostic.setloclist()
    vim.cmd("lopen")
end

local function jump_to_items(items, method, opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    local from = vim.fn.getpos(".")
    local tagname = vim.fn.expand("<cword>")

    from[1] = bufnr
    opts = opts or {}

    if vim.tbl_isempty(items) then
        return false
    end

    if opts.on_list then
        opts.on_list({
            title = "LSP locations",
            items = items,
            context = { bufnr = bufnr, method = method },
        })
        return true
    end

    if #items == 1 then
        local item = items[1]
        local target_buf = item.bufnr or vim.fn.bufadd(item.filename)
        local target_win = win

        vim.cmd("normal! m'")
        vim.fn.settagstack(vim.fn.win_getid(win), {
            items = { { tagname = tagname, from = from } },
        }, "t")

        vim.bo[target_buf].buflisted = true
        if opts.reuse_win and vim.api.nvim_win_get_buf(target_win) ~= target_buf then
            target_win = vim.fn.bufwinid(target_buf)
            target_win = target_win >= 0 and target_win or vim.fn.win_findbuf(target_buf)[1] or win
            if target_win ~= win then
                vim.api.nvim_set_current_win(target_win)
            end
        end

        vim.api.nvim_win_set_buf(target_win, target_buf)
        vim.api.nvim_win_set_cursor(target_win, { item.lnum, item.col - 1 })
        vim._with({ win = target_win }, function()
            vim.cmd("normal! zv")
        end)
        return true
    end

    if opts.loclist then
        vim.fn.setloclist(0, {}, " ", { title = "LSP locations", items = items })
        vim.cmd("lopen")
    else
        vim.fn.setqflist({}, " ", { title = "LSP locations", items = items })
        vim.cmd("botright copen")
    end

    return true
end

local function goto_with_fallback(methods, opts)
    local bufnr = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    opts = opts or {}

    local function request_method(index)
        local method = methods[index]
        if not method then
            vim.notify("No locations found", vim.log.levels.INFO)
            return
        end

        local clients = vim.lsp.get_clients({ method = method, bufnr = bufnr })
        if vim.tbl_isempty(clients) then
            request_method(index + 1)
            return
        end

        vim.lsp.buf_request_all(bufnr, method, function(client)
            return vim.lsp.util.make_position_params(win, client.offset_encoding)
        end, function(results)
            local items = {}

            for client_id, response in pairs(results) do
                local client = vim.lsp.get_client_by_id(client_id)
                local locations = {}
                if response and response.result then
                    locations = vim.islist(response.result) and response.result or { response.result }
                end
                if client then
                    vim.list_extend(items, vim.lsp.util.locations_to_items(locations, client.offset_encoding))
                end
            end

            if not jump_to_items(items, method, opts) then
                request_method(index + 1)
            end
        end)
    end

    request_method(1)
end

function M.goto_definition(opts)
    goto_with_fallback({
        "textDocument/definition",
        "textDocument/declaration",
        "textDocument/typeDefinition",
    }, opts)
end

function M.make_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, {
        workspace = {
            configuration = true,
        },
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
        },
    })

    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

    return capabilities
end

function M.with_defaults(config)
    return vim.tbl_deep_extend("force", {
        capabilities = M.make_capabilities(),
        on_attach = M.default_on_attach,
    }, config or {})
end

function M.extend_on_attach(extra_on_attach)
    return function(client, bufnr)
        M.default_on_attach(client, bufnr)
        if extra_on_attach then
            extra_on_attach(client, bufnr)
        end
    end
end

function M.setup_server(name, config)
    vim.lsp.config(name, M.with_defaults(config))
    vim.lsp.enable(name)
end

function M.attach_default_keymaps(bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", function()
        M.goto_definition({ reuse_win = true })
    end, opts)
    vim.keymap.set("n", "gr", telescope_or_lsp("lsp_references", vim.lsp.buf.references), opts)
    vim.keymap.set("n", "gI", telescope_or_lsp("lsp_implementations", vim.lsp.buf.implementation), opts)
    vim.keymap.set("n", "gy", telescope_or_lsp("lsp_type_definitions", vim.lsp.buf.type_definition), opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ls", telescope_or_lsp("lsp_document_symbols", vim.lsp.buf.document_symbol), opts)
    vim.keymap.set("n", "<leader>lS", workspace_symbols, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", list_workspace_folders, opts)
    vim.keymap.set("n", "<leader>li", function()
        toggle_inlay_hints(bufnr)
    end, opts)
    vim.keymap.set("n", "<leader>lc", function()
        if vim.lsp.codelens and vim.lsp.codelens.run then
            vim.lsp.codelens.run()
        end
    end, opts)
    vim.keymap.set("n", "<leader>lC", function()
        refresh_codelens(bufnr)
    end, opts)
    vim.keymap.set("n", "<leader>f", function()
        format_buffer(bufnr)
    end, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>dq", open_diagnostic_quickfix, opts)
    vim.keymap.set("n", "<leader>dl", open_diagnostic_loclist, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "[i", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]i", vim.diagnostic.goto_next, opts)
end

function M.setup_codelens(client, bufnr)
    if not client or not client.server_capabilities or not client.server_capabilities.codeLensProvider then
        return
    end

    local codelens_group = vim.api.nvim_create_augroup("LspCodeLens", { clear = false })
    vim.api.nvim_clear_autocmds({ group = codelens_group, buffer = bufnr })
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
        group = codelens_group,
        buffer = bufnr,
        callback = function()
            refresh_codelens(bufnr)
        end,
    })

    refresh_codelens(bufnr)
end

function M.setup_format_on_save(bufnr, filter)
    if not filter then
        return
    end
    local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })
    vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ async = false, bufnr = bufnr, filter = filter })
        end,
    })
end

function M.default_on_attach(client, bufnr)
    vim.b[bufnr].motleyfesst_lsp_attached_clients = vim.b[bufnr].motleyfesst_lsp_attached_clients or {}
    if vim.b[bufnr].motleyfesst_lsp_attached_clients[client.id] then
        return
    end
    vim.b[bufnr].motleyfesst_lsp_attached_clients[client.id] = true

    if not vim.b[bufnr].motleyfesst_lsp_keymaps_attached then
        M.attach_default_keymaps(bufnr)
        vim.b[bufnr].motleyfesst_lsp_keymaps_attached = true
    end

    M.setup_codelens(client, bufnr)
    require("motleyfesst.utils.fold").on_lsp_attach(client, bufnr)
end

local lsp_attach_group = vim.api.nvim_create_augroup("MotleyfesstLspAttach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_attach_group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end
        M.default_on_attach(client, args.buf)
    end,
})

return M
