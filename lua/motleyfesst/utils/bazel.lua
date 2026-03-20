local M = {}

M.ROOT_MARKERS = {
    "MODULE.bazel",
    "WORKSPACE.bazel",
    "WORKSPACE",
}

local function has_root_marker(path)
    for _, marker in ipairs(M.ROOT_MARKERS) do
        if vim.fn.filereadable(path .. "/" .. marker) == 1 then
            return true
        end
    end
    return false
end

function M.root_markers(extra_markers)
    local markers = vim.deepcopy(M.ROOT_MARKERS)
    if extra_markers then
        vim.list_extend(markers, extra_markers)
    end
    return markers
end

function M.find_workspace(start_dir)
    local workspace = start_dir
    while workspace and workspace ~= "" do
        if has_root_marker(workspace) then
            return workspace
        end

        local parent = vim.fn.fnamemodify(workspace, ":h")
        if parent == workspace then
            break
        end
        workspace = parent
    end
    return start_dir
end

function M.find_workspace_for_buf(bufnr)
    local buf_dir = vim.fn.expand(("#%d:p:h"):format(bufnr))
    return M.find_workspace(buf_dir)
end

function M.detach_conflicting_starlark_clients(bufnr)
    vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if client.name == "starlark_rust" then
                vim.lsp.buf_detach_client(bufnr, client.id)
            end
        end
    end)
end

return M
