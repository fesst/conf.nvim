I like setup separation with one or more file per plugin.

I would like to have a good groupped information about all mappings we set up in wiki/mappings.md Also highlight which defaults are overriden.

Plugins should be in after/plugins
General should be in lua./motleyfesst

Additional installation scripts should be in infra/ folder.

All settings that should be installed separately from lazy should be prioritized like this:
- brew packages
- npm packages
- cargo packages
- pip packages

Any installation should be done via infra/install.sh and checked in infra/cleanup.sh.