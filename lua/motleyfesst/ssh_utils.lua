local function get_ssh()
    return os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")
end

local function get_tmux()
    return os.getenv("TMUX")
end

local function IS_SSH()
    local ssh_conn = get_ssh()
    return ssh_conn and ssh_conn ~= ""
end

local function IS_IN_TMUX()
    local tmux_var = get_tmux()
    return tmux_var and tmux_var ~= ""
end

local function IS_NOT_SSH()
    return not IS_SSH()
end

local function IS_TMUX_IN_SSH()
    return IS_IN_TMUX() and IS_SSH()
end

local function IS_ZSH()
    local shell = os.getenv("SHELL") or ""
    return string.match(shell, "zsh")
end

local function IS_NOT_ZSH()
    return not IS_ZSH()
end

local function IS_MAC()
    return IS_ZSH() and IS_NOT_SSH()
end

local function IS_WIN()
    return IS_NOT_ZSH() and IS_NOT_SSH()
end

local function IS_LINUX_SERVER()
    return IS_NOT_ZSH() and IS_SSH()
end

return {
    IS_MAC = IS_MAC,
    IS_WIN = IS_WIN,
    IS_LIN = IS_LINUX_SERVER,
    IS_ZSH = IS_ZSH,
    IS_NOT_SSH = IS_NOT_SSH,
    IS_NOT_ZSH = IS_NOT_ZSH
}
