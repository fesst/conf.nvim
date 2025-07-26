local function get_ssh()
    return os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")
end

local function get_tmux()
    return os.getenv("TMUX")
end

local function IS_NOT_SSH()
    local ssh_conn = get_ssh()
    return (ssh_conn == nil) or (ssh_conn == "")
end

local function IS_SSH()
    return not IS_NOT_SSH()
end

local function IS_IN_TMUX()
    local tmux_var = get_tmux()
    return tmux_var and tmux_var ~= ""
end

local function IS_TMUX_IN_SSH()
    return IS_IN_TMUX() and IS_SSH()
end

return {
    IS_SSH = IS_SSH,
    IS_IN_TMUX = IS_IN_TMUX,
    IS_TMUX_IN_SSH = IS_TMUX_IN_SSH,
    IS_NOT_SSH = IS_NOT_SSH,
}
