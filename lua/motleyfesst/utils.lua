function IS_SSH()
    return os.getenv("SSH_CONNECTION") or os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")
end

function IS_IN_TMUX()
    return os.getenv("TMUX")
end

function IS_TMUX_IN_SSH()
    return IS_IN_TMUX() and IS_SSH()
end

function IS_NOT_SSH()
    return not IS_SSH()
end
