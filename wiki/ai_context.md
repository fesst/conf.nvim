# Vim lua config

## General repo rules

### Lua file structure
- Plugins should be in after/plugin (that is important path!)
- General should be in lua./motleyfesst

- We prefer setup separation with one or more file per plugin.
- All plugin setup should be in after/plugins as a rule of thumb, but(!) related functionality is better to place altogether.
- As a rule of thumb it is better to place something to comply with already presented structure. If it is vague or/and unexplained — we need to update this file first to be on the same page before proceeding.

### Wiki
- We have to document groupped information about all mappings we set up in wiki/mappings.md.
Also highlight which defaults are overriden and propose solutions immediately as soon as conflicts should be avoided with exception of more sophisticated functionality with similar usage.

### test apps
- test/ folder contains some test lua scripts and test applications to check LSP and DAP functionality.


### Infrastructure
- Additional installation scripts should be in infra/ folder.

- All settings that should be installed separately from lazy should be prioritized like this:
  - brew packages
  - npm packages
  - cargo packages
  - pip packages

- Any installation should be done via infra/install.sh and synced in infra/cleanup.sh.

## Remapping Rules
- Only encode actual remaps in remap.lua (do not remap defaults to themselves)
- Document all overridden (only non-default!) mappings in wiki/mappings.md.
- Group related mappings together with clear comments.
- Use descriptive comments for each mapping group.
- Never override default commands that have functionality. Reasoning is to easily work with help without remembering all the mappings, at least until it's going to become so.

## Check actuality
- Note: Some language parsers (Angular, Dockerfile, Fennel, Groovy, LaTeX, Svelte, Vue) are currently disabled due to compatibility issues.
- If there will be possibility to check it periodically with AI it would be cool but it is definitely not necessary to do every time.

## Testing after changes
- Always test install.sh on change.
- Always test nvim configuration on plugin changes, do it with --headless.

## VCS
- add everything, read and summarize and then commit and push. One-line command is preferrable choice until there are reasons to separate.
