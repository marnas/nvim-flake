## :books: Usage

1. Click on [Use this template](https://github.com/nix-community/kickstart-nix.nvim/generate)
to start a repo based on this template. **Do _not_ fork it**.
1. Add/remove plugins to/from the [Neovim overlay](./nix/neovim-overlay.nix).
1. Add/remove plugin configs to/from the `nvim/plugin` directory.
1. Modify as you wish (you will probably want to add a color theme, ...).
   See: [Design](#robot-design).
1. You can create more than one package using the `mkNeovim` function by
    - Passing different plugin lists.
    - Adding `ignoreConfigRegexes` (e.g. `= [ "^ftplugin/.*.lua" ]`).

> [!TIP]
>
> The nix and lua files contain comments explaining
> what everything does in detail.

## :zap: Installation

### :snowflake: NixOS (with flakes)

1. Add your flake to you NixOS flake inputs.
1. Add the overlay provided by this flake.

```nix
nixpkgs.overlays = [
    # replace <kickstart-nix-nvim> with the name you chose
    <kickstart-nix-nvim>.overlays.default
];
```

You can then add the overlay's output(s) to the `systemPackages`:

```nix
environment.systemPackages = with pkgs; [
    nvim-pkg # The default package added by the overlay
];
```

> [!IMPORTANT]
>
> This flake uses `nixpkgs.wrapNeovimUnstable`, which has an
> unstable signature. If you set `nixpkgs.follows = "nixpkgs";`
> when importing this into your flake.nix, it may break.
> Especially if your nixpkgs input pins a different branch.

### :penguin: Non-NixOS

With Nix installed (flakes enabled), from the repo root:

```console
nix profile install .#nvim
```

## :robot: Design

Directory structure:

```sh
── flake.nix
── nvim # Neovim configs (lua), equivalent to ~/.config/nvim
── nix # Nix configs
```

### :open_file_folder: Neovim configs

- Set options in `init.lua`.
- Source autocommands, user commands, keymaps,
  and configure plugins in individual files within the `plugin` directory.
- Filetype-specific scripts (e.g. start LSP clients) in the `ftplugin` directory.
- Library modules in the `lua/user` directory.

Directory structure:

```sh
── nvim
  ├── ftplugin # Sourced when opening a file type
  │  └── <filetype>.lua
  ├── init.lua # Always sourced
  ├── lua # Shared library modules
  │  └── user
  │     └── <lib>.lua
  ├── plugin # Automatically sourced at startup
  │  ├── autocommands.lua
  │  ├── commands.lua
  │  ├── keymaps.lua
  │  ├── plugins.lua # Plugins that require a `setup` call
  │  └── <plugin-config>.lua # Plugin configurations
  └── after # Empty in this template
     ├── plugin # Sourced at the very end of startup (rarely needed)
     └── ftplugin # Sourced when opening a filetype, after sourcing ftplugin scripts
```

> [!IMPORTANT]
>
> - Configuration variables (e.g. `vim.g.<plugin_config>`) should go in `nvim/init.lua`
>   or a module that is `require`d in `init.lua`.
> - Configurations for plugins that require explicit initialization
>   (e.g. via a call to a `setup()` function) should go in `nvim/plugin/<plugin>.lua`
>   or `nvim/plugin/plugins.lua`.
> - See [Initialization order](#initialization-order) for details.

### :open_file_folder: Nix

You can declare Neovim derivations in `nix/neovim-overlay.nix`.

There are two ways to add plugins:

- The traditional way, using `nixpkgs` as the source.
- By adding plugins as flake inputs (if you like living on the bleeding-edge).
  Plugins added as flake inputs must be built in `nix/plugin-overlay.nix`.

Directory structure:

```sh
── flake.nix
── nix
  ├── mkNeovim.nix # Function for creating the Neovim derivation
  └── neovim-overlay.nix # Overlay that adds Neovim derivation
```

### :mag: Initialization order

This derivation creates an `init.lua` as follows:

1. Add `nvim/lua` to the `runtimepath`.
1. Add the content of `nvim/init.lua`.
1. Add `nvim/*` to the `runtimepath`.
1. Add `nvim/after` to the `runtimepath`.

This means that modules in `nvim/lua` can be `require`d in `init.lua` and `nvim/*/*.lua`.

Modules in `nvim/plugin/` are sourced automatically, as if they were plugins.
Because they are added to the runtime path at the end of the resulting `init.lua`,
Neovim sources them _after_ loading plugins.

## :electric_plug: Pre-configured plugins

This configuration comes with [a few plugins pre-configured](./nix/neovim-overlay.nix).

You can add or remove plugins by

- Adding/Removing them in the [Nix list](./nix/neovim-overlay.nix).
- Adding/Removing the config in `nvim/plugin/<plugin>.lua`.

## :anchor: Syncing updates

If you have used this template and would like to fetch updates
that were added later...

Add this template as a remote:

```console
git remote add upstream git@github.com:nix-community/kickstart-nix.nvim.git
```

Fetch and merge changes:

```console
git fetch upstream
git merge upstream/main --allow-unrelated-histories
```

## :pencil: Editing your config

When your neovim setup is a nix derivation, editing your config
demands a different workflow than you are used to without nix.
Here is how I usually do it:

- Perform modifications and stage any new files[^2].
- Run `nix run /path/to/neovim/#nvim`
  or `nix run /path/to/neovim/#nvim -- <nvim-args>`

[^2]: When adding new files, nix flakes won't pick them up unless they
      have been committed or staged.

This requires a rebuild of the `nvim` derivation, but has the advantage
that if anything breaks, it's only broken during your test run.

If you want an impure, but faster feedback loop,
you can use `$XDG_CONFIG_HOME/$NVIM_APPNAME`[^3], where `$NVIM_APPNAME` 
defaults to `nvim` if the `appName` attribute is not set 
in the `mkNeovim` function.

[^3]: Assuming Linux. Refer to `:h initialization` for Darwin.

This has one caveat: The wrapper which nix generates for the derivation
calls `nvim` with `-u /nix/store/path/to/generated-init.lua`.
So it won't source a local `init.lua` file.
To work around this, you can put scripts in the `plugin` or `after/plugin` directory.
