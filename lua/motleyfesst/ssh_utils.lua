local function is_nonempty(s)
    return s ~= nil and s ~= ""
end

local function IS_SSH()
    return is_nonempty(os.getenv("SSH_CONNECTION"))
        or is_nonempty(os.getenv("SSH_CLIENT"))
        or is_nonempty(os.getenv("SSH_TTY"))
end

local function IS_IN_TMUX()
    return is_nonempty(os.getenv("TMUX"))
end

local function IS_TMUX_IN_SSH()
    return IS_IN_TMUX() and IS_SSH()
end

local function IS_NOT_SSH()
    return not IS_SSH()
end

local function IS_LOCAL()
    return IS_NOT_SSH()
end

local function IS_ZSH()
    local shell = os.getenv("SHELL") or ""
    return shell:match("zsh") ~= nil
end

local function IS_MAC()
    return vim.fn.has("mac") == 1
end

local function IS_WIN()
    return vim.fn.has("win32") == 1
end

local function IS_LIN()
    return vim.fn.has("linux") == 1
end

return {
    IS_LOCAL = IS_LOCAL,
    IS_SSH = IS_SSH,
    IS_IN_TMUX = IS_IN_TMUX,
    IS_TMUX_IN_SSH = IS_TMUX_IN_SSH,
    IS_NOT_SSH = IS_NOT_SSH,
    IS_ZSH = IS_ZSH,
    IS_MAC = IS_MAC,
    IS_WIN = IS_WIN,
    IS_LIN = IS_LIN,
}
