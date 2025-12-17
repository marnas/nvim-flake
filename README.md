# nvim-flake

A fully reproducible Neovim configuration packaged as a Nix flake. This setup bundles Neovim with all plugins, LSP servers, and tools into a single self-contained derivation that can be used anywhere Nix is available.

## Features

- **Zero configuration required** - Just run and use
- **Fully reproducible** - Same config, same behavior, everywhere
- **All dependencies included** - LSP servers, formatters, and tools bundled in PATH
- **Multiple installation methods** - Try it, install it, or import it into your NixOS config

### Included Tools

- **LSP Servers**: nixd, gopls, rust-analyzer, lua-language-server, terraform-ls, tflint, helm-ls, yaml-language-server, vscode-langservers-extracted (jsonls)
- **Plugins**: telescope, neo-tree, gitsigns, leap, blink-cmp, copilot, lualine, render-markdown, and more
- **Theme**: Monokai Pro

## Quick Start

### Try without installing

The fastest way to try this configuration:

```bash
nix run github:marnas/nvim-flake
```

Or with a file:

```bash
nix run github:marnas/nvim-flake -- myfile.txt
```

This downloads and runs the configuration without installing anything permanently.

## Installation

### NixOS (with flakes)

Add to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvim-flake.url = "github:marnas/nvim-flake";
  };

  outputs = { nixpkgs, nvim-flake, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          nixpkgs.overlays = [ nvim-flake.overlays.default ];
          environment.systemPackages = with pkgs; [
            nvim-pkg
          ];
        }
      ];
    };
  };
}
```

> [!IMPORTANT]
>
> This flake uses `nixpkgs.wrapNeovimUnstable`, which has an unstable signature.
> Avoid setting `nixpkgs.follows = "nixpkgs"` when importing this flake, as it may break
> if your nixpkgs input pins a different branch.

### Non-NixOS / Home Manager

Install to your profile:

```bash
# From the repo root
nix profile install .#nvim

# Or directly from GitHub
nix profile install github:marnas/nvim-flake
```

Or use in a development shell:

```bash
nix shell github:marnas/nvim-flake
```

## Project Structure

```
.
├── flake.nix                    # Flake entry point
├── nix/
│   ├── neovim-overlay.nix      # Plugin and package declarations
│   └── mkNeovim.nix            # Neovim derivation builder
└── nvim/                        # Neovim configuration (like ~/.config/nvim)
    ├── init.lua                # Main init file
    └── lua/
        ├── core/               # Core settings and keymaps
        └── plugins/            # Plugin configurations
```

### How it works

1. **neovim-overlay.nix** lists all plugins and external packages (LSPs, tools)
2. **mkNeovim.nix** bundles everything together:
   - Installs all plugins
   - Copies your lua configs
   - Adds all tools to PATH
3. **Result**: A single `nvim` binary with everything included

## Customization

### Adding/Removing Plugins

Edit `nix/neovim-overlay.nix`:

```nix
all-plugins = with pkgs.vimPlugins; [
  telescope-nvim
  neo-tree-nvim
  # Add your plugins here (alphabetically sorted)
];
```

Then add the plugin's configuration in `nvim/lua/plugins/<plugin-name>.lua` and require it in `nvim/init.lua`.

### Adding/Removing LSP Servers

Edit `nix/neovim-overlay.nix`:

```nix
extraPackages = with pkgs; [
  lua-language-server
  rust-analyzer
  # Add your tools here
];
```

Then configure the LSP in `nvim/lua/plugins/lsp.lua`.

### Language Server Configuration

All LSP servers are configured in `nvim/lua/plugins/lsp.lua` using the new `vim.lsp.config()` API. Current servers:

- **nixd** - Nix with formatting via nixfmt
- **lua_ls** - Lua with Neovim API support
- **gopls** - Go
- **rust_analyzer** - Rust with proc macros enabled
- **jsonls** - JSON
- **terraformls** & **tflint** - Terraform
- **helm_ls** - Helm charts
- **yamlls** - YAML with Kubernetes schemas

## Development Workflow

When editing this flake:

1. Make changes to files in `nvim/` or `nix/`
2. Stage new files (required for flakes): `git add .`
3. Test your changes: `nix run .` or `nix run . -- test.txt`

This rebuilds the derivation with your changes. If something breaks, it only affects the test run.

### Faster feedback loop

For rapid iteration, you can also use `~/.config/nvim` for quick tests:
- The nix derivation generates init.lua, so local `init.lua` won't be sourced
- Put test scripts in `~/.config/nvim/plugin/` or `~/.config/nvim/after/plugin/`
- Once tested, port changes back to the flake

## Included Plugins

- **blink-cmp** - Fast completion engine
- **copilot-vim** - GitHub Copilot integration
- **gitsigns** - Git decorations
- **leap** - Lightning-fast motion
- **lualine** - Statusline
- **markdown-preview** - Live markdown preview
- **monokai-pro** - Color scheme
- **neo-tree** - File explorer
- **neoscroll** - Smooth scrolling
- **nvim-treesitter** - Syntax highlighting (all grammars included)
- **nvim-web-devicons** - File icons
- **plenary** - Lua utilities
- **render-markdown** - Better markdown rendering
- **telescope** - Fuzzy finder
- **toggleterm** - Terminal management
- **vim-helm** - Helm chart support
- **vim-terraform** - Terraform support
- **vim-tmux-navigator** - Seamless tmux/vim navigation

---

Based on [kickstart-nix.nvim](https://github.com/nix-community/kickstart-nix.nvim)
