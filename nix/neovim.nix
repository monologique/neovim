{
  lib,
  lua-language-server,
  nixd,
  makeWrapper,
  neovim-unwrapped,
  symlinkJoin,
  vimPlugins,
  wrapNeovim,
  stylua,
}:
let
  bins = [
    lua-language-server
    nixd
    stylua
  ];

  neovim = wrapNeovim neovim-unwrapped {
    viAlias = true;
    vimAlias = true;

    configure = {
      customRC = ''
        luafile $HOME/.config/nvim/init.lua
      '';

      packages.all.start = with vimPlugins; [
        nvim-treesitter.withAllGrammars
        guess-indent-nvim
        oil-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        lazydev-nvim
        telescope-nvim
        mini-snippets
      ];
    };
  };
in
symlinkJoin {
  name = "monovim";
  paths = [ neovim ] ++ bins;
  buildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath bins}
  '';
}
