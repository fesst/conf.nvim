I like setup separation with one or more file per plugin. All plugin setup should be in after/plugins.

I would like to have a good groupped information about all mappings we set up in wiki/mappings.md Also highlight which defaults are overriden.

Plugins should be in after/plugin (that is important path!)
General should be in lua./motleyfesst

Additional installation scripts should be in infra/ folder.

All settings that should be installed separately from lazy should be prioritized like this:
- brew packages
- npm packages
- cargo packages
- pip packages

Any installation should be done via infra/install.sh and checked in infra/cleanup.sh.

# Tree-sitter Configuration

Tree-sitter is configured in `after/plugin/treesitter.lua`. It provides advanced syntax highlighting and code manipulation features.

## Supported Languages
The configuration includes support for many programming languages including:
- Common languages: Python, JavaScript, TypeScript, Java, C/C++
- Web: HTML, CSS, SCSS, JSON, YAML
- Functional: Haskell, OCaml, Scheme, Clojure
- Scripting: Lua, Ruby, PHP, Perl
- And many more

Note: Some language parsers (Angular, Dockerfile, Fennel, Groovy, LaTeX, Svelte, Vue) are currently disabled due to compatibility issues.

# Theme Configuration

The rose-pine theme is configured in `lua/motleyfesst/lazy.lua` as part of the plugin specification. This ensures proper loading order and integration with lazy.nvim.

## Rose-pine Theme
- Uses the "alt" variant for both light and dark modes
- Configured directly in the plugin specification for proper loading
- Set with high priority (1000) to ensure it loads before other plugins
- Non-lazy loaded to ensure immediate availability
