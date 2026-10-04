{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -lh --icons --git";
      la = "eza -lah --icons --git";
      tree = "eza --tree --icons";
      grep = "rg --color=auto";
      update = "sudo zsh /home/sv_abd/my-nixos-config/bash/system.sh";
      collect = "sudo zsh /home/sv_abd/my-nixos-config/bash/nixos-garbage-collect.sh";
    };

    history = {
      size = 10000;
      path = "${config.home.homeDirectory}/.zsh_history";
      ignoreAllDups = true;
    };

    # Home Manager allows clean mapping of external Nix plugins
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    # Optional: Replace the standard 'cd' command with zoxide entirely
    options = ["--cmd cd"];
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.eza = {
    enable = true;
    git = true;
    icons = "auto"; # Options: "always", "auto", "never"
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];

    # Enable shell-specific integrations to automatically alias `ls` to `eza`
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };
  programs.fd = {
    enable = true;
    hidden = true; # Include hidden files by default
    ignores = [
      ".git/"
      "node_modules/"
    ];
  };
  home.packages = with pkgs; [
    ripgrep
  ];
  programs.bat = {
    enable = true;
    config = {
      theme = "GitHub";
      pager = "less -FR";
    };
  };
}
