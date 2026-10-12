{
  pkgs,
  config,
  ...
}: {
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
