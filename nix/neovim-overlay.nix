# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix { inherit pkgs-wrapNeovim; };

  all-plugins = with pkgs.vimPlugins; [
    # Active plugins
    blink-cmp
    copilot-vim
    gitsigns-nvim
    leap-nvim
    lualine-nvim
    markdown-preview-nvim
    monokai-pro-nvim
    neo-tree-nvim
    neoscroll-nvim
    nvim-lspconfig
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
    nvim-web-devicons
    plenary-nvim
    render-markdown-nvim
    telescope-nvim
    toggleterm-nvim
    vim-helm
    vim-terraform
    vim-tmux-navigator

    # Disabled plugins
    # alpha-nvim
    # bufferline-nvim
    # codecompanion-nvim
    # friendly-snippets
    # telescope-fzy-native-nvim

    # Old nvim-cmp plugins (to be removed eventually)
    # cmp-buffer
    # cmp-cmdline
    # cmp-cmdline-history
    # cmp-nvim-lsp
    # cmp-nvim-lsp-signature-help
    # cmp-nvim-lua
    # cmp-path
    # cmp_luasnip
    # diffview-nvim
    # lspkind-nvim
    # luasnip
    # neogit
    # nvim-cmp
    # vim-fugitive
  ];

  extraPackages = with pkgs; [
    # Language servers
    gopls
    helm-ls
    lua-language-server
    nixd
    rust-analyzer
    terraform-ls
    tflint
    vscode-langservers-extracted
    yaml-language-server

    # Formatters
    nixfmt-classic

    # Tools
    fd
    ripgrep
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
