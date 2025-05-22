# Vim lua config

## General repo rules


### File structure


#### Lua files structure

- Plugins setup should be in after/plugin (that is important path!)
- General should be in lua/motleyfesst

##### New lua files rules

- All plugin setup should be in after/plugin. Including their keymappings.
- We think that related functionality is better to place altogether. But if makes sense, we can separate, like we did with lsp.lua and languages.lua.
- As a rule of thumb it is better to place something to comply with already presented structure. If it is vague or/and unexplained — we need to update this file first to be on the same page before proceeding.


#### Wiki

- We have to document groupped information about all mappings we set up in wiki/mappings.md.
- Especially document all overridden (but only non-default!) mappings in wiki/mappings.md.
- Highlight which defaults are overriden and propose solutions immediately as soon as conflicts should be avoided with the exception of more sophisticated functionality with similar usage.



#### Test apps

- test/ folder contains some test lua scripts and test applications to check LSP and DAP functionality.


#### Infrastructure

- Additional installation scripts should be in infra/ folder.

- All settings that should be installed separately from lazy should be prioritized like this:
  - brew packages
  - npm packages
  - cargo packages
  - pip packages

- Any installation should be done via infra/install.sh and synced in infra/cleanup.sh.

- Duplication in install.sh and cleanup.sh should be avoided by putting it into lib.sh.
- We do not support cross-platform for now.



## General remapping rules

- Group related mappings together with clear comments.
- Use descriptive comments for each mapping group.
- As a rule of thumb do not override default commands that have functionality.
  Reasoning is to easily work with help without remembering all the mappings, at least until it's going to become so, but with the exception of more sophisticated functionality with similar usage.
- Only encode actual remaps in remap.lua (do not remap defaults to themselves). Last state is setting leader. Propose thoroughly!


## Check issues actuality

- To get date, run shell command date.
- Note: All previously disabled language parsers (Angular, Dockerfile, Fennel, Groovy, LaTeX, Svelte, Vue) are now available and can be enabled. [Last checked: 2025-05-20]
- If there will be possibility to check it periodically with AI it would be cool but it is definitely not necessary to do every time.


## Testing after changes

- Always test install.sh on its change.
- Always test nvim configuration on nvim plugin changes, do it with --headless and do not forget to quit after if needed.


## VCS

- pushall means:
add everything, read and summarize and then commit and push. One-line command is preferrable choice until there are reasons to separate.


## null-ls specialty (important)

- **null-ls.nvim** is a Neovim plugin that acts as a bridge between external formatters/linters and the built-in LSP client. It is **not** a language server itself and should **not** be set up via `lspconfig` as a server.
- All null-ls configuration should be placed in `after/plugin/` (e.g., `after/plugin/null-ls.lua`).
- Do **not** attempt to register null-ls as an LSP server in `lspconfig`.
- This specialty is important for avoiding misconfiguration and errors.
