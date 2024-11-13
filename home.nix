{ config, pkgs, ... }:

{
  home.username = "joogie";
  home.homeDirectory = "/home/joogie";
  home.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    awscli2
    ffmpeg
    fnm
    fzf
    gh
    ripgrep
    rustup
    starship
    tmux
    zoxide
  ];

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file = {
    ".tmux.conf".source = ./config/.tmux.conf;
    ".config/starship.toml".source = ./config/starship.toml;
    ".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs = {
    home-manager = { enable = true; };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "tmux"
          "z"
          "vi-mode"
        ];
      };

      shellAliases = {
        cls = "clear";
        x = "exit";
        t = "tmux";
      };
      
      initExtra = ''
	# added by Nix installer
        if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi

        export PATH=$PATH:$HOME/.cargo/bin
        export PATH=$PATH:$HOME/.local/bin
        export PATH=$PATH:$HOME/.local/share/bob/nvim-bin

        # fnm
        export PNPM_HOME="/home/joogie/.local/share/pnpm"
        case ":$PATH:" in
          *":$PNPM_HOME:"*) ;;
          *) export PATH="$PNPM_HOME:$PATH" ;;
        esac

        export PATH="$HOME/.local/share/fnm:$PATH"
        eval "$(fnm env)"
        # fnm end

        bindkey -M viins jj vi-cmd-mode
        export VI_MODE_SET_CURSOR=true
      '';
    };
  };
}
