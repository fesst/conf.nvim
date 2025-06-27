function is_not_ssh()
    local ssh = os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")
    return not ssh
end

local function in_tmux_and_ssh()
    local tmux = os.getenv("TMUX")
    local ssh = os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")
    return tmux and ssh
end
