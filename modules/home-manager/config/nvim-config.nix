{ pkgs, ... }: {
  # Install Neovim and required external dependencies (LSPs, compilers, formatters)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # Pre-inject CLI packages so Mason or standard Lua configs can access them on NixOS
    extraPackages = with pkgs; [
      lua-language-server
      nil
      ripgrep
      gcc
    ];
  };

  # Symlink your local directory to ~/.config/nvim
  home.file.".config/nvim" = {
    source = ./../../../raw/nvim.lua; # Relative path to your dotfiles repo
    recursive = true;
  };
}

