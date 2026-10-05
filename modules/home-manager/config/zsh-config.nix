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
      update = "${config.updateScript}";
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
  programs.starship = {
    enable = true;
    # Automatically integrates with bash, zsh, fish, etc.
    enableBashIntegration = true;
    enableZshIntegration = true;

    # Write your starship.toml configurations here
    settings = {
      add_newline = false;
      format = "$all";
    };
  };
  programs.tmux = {
    enable = true;
    mouse = true; # Enable mouse scrolling and pane selection
    historyLimit = 10000; # Boost history limit
    newSession = true; # Automatically spawn a session if trying to attach and none exist

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'mocha'
        '';
      }
      yank
    ];

    extraConfig = ''
      # Enable 256 color terminal support
      set -g default-terminal "screen-256color"
    '';
  };
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "sv_abd";
        email = "duismana@gmail.com";
      };
    };
  };
}
