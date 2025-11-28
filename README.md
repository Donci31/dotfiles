# Dotfiles

Personal dotfiles managed with [Dotter](https://github.com/SuperCuber/dotter).

## Contents

This repository contains configuration files for:

- **[Neovim](https://neovim.io/)** - LazyVim-based text editor configuration
- **[Wezterm](https://wezfurlong.org/wezterm/)** - Terminal emulator
- **[Nushell](https://www.nushell.sh/)** - Modern shell with structured data
- **[Starship](https://starship.rs/)** - Cross-shell prompt
- **[Yazi](https://yazi-rs.github.io/)** - Terminal file manager
- **[MPV](https://mpv.io/)** - Media player
- **[pgcli](https://www.pgcli.com/)** - PostgreSQL CLI with autocompletion

## Structure

```
.
├── .dotter/          # Dotter configuration
│   ├── global.toml   # Deployment targets and settings
│   └── local.toml    # Local machine-specific settings (gitignored)
├── mpv/              # MPV media player configuration
├── nushell/          # Nushell shell configuration
│   ├── config.nu     # Main Nushell config
│   ├── env.nu        # Environment variables
│   ├── aws_lib.nu    # AWS-related utilities
│   └── lazyglue.nu   # Custom utilities
├── nvim/             # Neovim configuration (LazyVim)
│   ├── init.lua      # Entry point
│   └── lazy-lock.json # Plugin lockfile
├── pgcli/            # PostgreSQL CLI configuration
├── starship/         # Starship prompt configuration
├── wezterm/          # Wezterm terminal configuration
│   └── .wezterm.lua  # Main config file
└── yazi/             # Yazi file manager configuration
    ├── yazi.toml     # General settings
    ├── keymap.toml   # Key bindings
    └── theme.toml    # Theme configuration
```

## Installation

Install [Dotter](https://github.com/SuperCuber/dotter):

```bash
# On Windows with Scoop
scoop install dotter

# Or with Cargo
cargo install dotter
```

### Deploy

1. Clone this repository:

```bash
git clone https://github.com/Donci31/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Deploy the dotfiles:

```bash
dotter deploy
```

This will symlink the configuration files to their appropriate locations as defined in `.dotter/global.toml`:

- `mpv` → `~/scoop/persist/mpv/portable_config/`
- `nushell` → `~/AppData/Roaming/nushell/`
- `nvim` → `~/AppData/Local/nvim/`
- `pgcli` → `~/AppData/Local/dbcli/pgcli/`
- `starship` → `~/.config/`
- `wezterm` → `~`
- `yazi` → `~/AppData/Roaming/yazi/config/`

## Configuration Management

### Adding New Configurations

1. Add the configuration files to the appropriate directory
2. Update `.dotter/global.toml` with the deployment target
3. Run `dotter deploy` to apply changes

### Machine-Specific Settings

Create `.dotter/local.toml` for machine-specific configurations that shouldn't be tracked in git.
