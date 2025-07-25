# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;

  # Use this to create a plugin from a flake input
  # mkNvimPlugin = src: pname:
  #   pkgs.vimUtils.buildVimPlugin {
  #     inherit pname src;
  #     version = src.lastModifiedDate;
  #   };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    monokai-pro-nvim
    neo-tree-nvim
    # bufferline-nvim
    vim-tmux-navigator
    gitsigns-nvim
    nvim-lspconfig
    # alpha-nvim
    leap-nvim
    vim-helm
    toggleterm-nvim

    blink-cmp
    # friendly-snippets
    vim-terraform
    render-markdown-nvim
    markdown-preview-nvim
    neoscroll-nvim
    # codecompanion-nvim
    copilot-vim

    # TO be removed
    # nvim-cmp (autocompletion) and extensions
    # nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    # luasnip
    # cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    # cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    # cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    # cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    # cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    # cmp-cmdline # cmp command line suggestions
    # cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    # cmp-cmdline-history # cmp command line history suggestions
    # lspkind-nvim
    # ^ nvim-cmp extensions
    # git integration plugins
    # diffview-nvim # https://github.com/sindrets/diffview.nvim/
    # neogit # https://github.com/TimUntersberger/neogit/
    # vim-fugitive # https://github.com/tpope/vim-fugitive/
    # ^ git integration plugins
    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    # telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-treesitter.withAllGrammars
    # libraries that other plugins depend on
    plenary-nvim
    nvim-web-devicons
  ];

  extraPackages = with pkgs; [
    # language servers, etc.
    ripgrep
    fd
    nixd
    gopls
    vscode-langservers-extracted
    nil # nix LSP
    nixfmt-classic
    lua-language-server
    yaml-language-server
    helm-ls
    terraform-ls
    tflint
    rust-analyzer
  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json { plugins = all-plugins; };

}
