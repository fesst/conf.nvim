local function get_ssh()
    return os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")
end

local function get_tmux()
    return os.getenv("TMUX")
end

local function IS_SSH()
    return not IS_NOT_SSH()
end

local function IS_IN_TMUX()
    return not (get_tmux() == "")
end

local function IS_TMUX_IN_SSH()
    return IS_IN_TMUX() and IS_SSH()
end

local function IS_NOT_SSH()
    local ssh_conn = get_ssh()
    return (ssh_conn == nil) or (ssh_conn == "")
end

return {
    IS_NOT_SSH = IS_NOT_SSH
}
