# Function for creating the Neovim derivation
{
  pkgs,
  lib,
  # Set by the overlay to ensure we use a compatible version of `wrapNeovimUnstable`
  pkgs-wrapNeovim ? pkgs,
}:
{
  # List of plugins; each entry is a package or an attrset
  # { plugin = <package>; config = <string>; optional = <bool>; }
  plugins ? [ ],
  extraPackages ? [ ], # Extra runtime dependencies (e.g. ripgrep, language servers, ...)
}:
let
  defaultPlugin = {
    plugin = null;
    config = null;
    # If `optional` is true, the plugin is installed in the 'opt' packpath
    # and can be lazy loaded with ':packadd! {plugin-name}'
    optional = false;
  };

  # Map all plugins to an attrset { plugin = <plugin>; config = <config>; optional = <tf>; }
  normalizedPlugins = map (x: defaultPlugin // (if x ? plugin then x else { plugin = x; })) plugins;

  # Split runtimepath into 3 directories:
  # - lua, to be prepended to the rtp at the beginning of init.lua
  # - nvim, containing plugin, ftplugin, ... subdirectories
  # - after, to be sourced last in the startup initialization
  # See also: https://neovim.io/doc/user/starting.html
  nvimRtp = pkgs.stdenv.mkDerivation {
    name = "nvim-rtp";
    src = ../nvim;

    buildPhase = ''
      mkdir -p $out/nvim
      mkdir -p $out/lua
      rm init.lua
    '';

    installPhase = ''
      cp -r lua $out/lua
      rm -r lua
      # Copy nvim/after only if it exists
      if [ -d "after" ]; then
          cp -r after $out/after
          rm -r after
      fi
      # Copy rest of nvim/ subdirectories only if they exist
      if [ ! -z "$(ls -A)" ]; then
          cp -r -- * $out/nvim
      fi
    '';
  };

  # The final init.lua content that we pass to the Neovim wrapper.
  # It wraps the user init.lua and prepends the lua lib directory to the RTP.
  initLua =
    ''
      vim.loader.enable()
      -- prepend lua directory
      vim.opt.rtp:prepend('${nvimRtp}/lua')
    ''
    # Wrap init.lua
    + (builtins.readFile ../nvim/init.lua)
    # Prepend nvim and after directories to the runtimepath
    # NOTE: This is done after init.lua,
    # because of a bug in Neovim that can cause filetype plugins
    # to be sourced prematurely, see https://github.com/neovim/neovim/issues/19008
    # We prepend to ensure that user ftplugins are sourced before builtin ftplugins.
    + ''
      vim.opt.rtp:prepend('${nvimRtp}/nvim')
      vim.opt.rtp:prepend('${nvimRtp}/after')
    '';
in
# wrapNeovimUnstable is the nixpkgs utility function for building a Neovim derivation.
pkgs-wrapNeovim.wrapNeovimUnstable pkgs-wrapNeovim.neovim-unwrapped {
  withPython3 = true;
  withRuby = false;
  withNodeJs = false;
  viAlias = true;
  vimAlias = true;
  plugins = normalizedPlugins;
  luaRcContent = initLua;
  # Add external packages to the PATH
  wrapperArgs = lib.optionalString (
    extraPackages != [ ]
  ) ''--prefix PATH : "${lib.makeBinPath extraPackages}"'';
  wrapRc = true;
}
