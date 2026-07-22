{lib, ...}: let
  lua = lib.generators.mkLuaInline;

  # ---- small helpers to keep the bind/on lists readable ----

  # A bind with no extra flags: hl.bind(key, dispatcher)
  bind = key: dispatcher: {
    _args = [key (lua dispatcher)];
  };

  # A bind with a flags table: hl.bind(key, dispatcher, { locked = true; ... })
  bindFlags = key: dispatcher: flags: {
    _args = [key (lua dispatcher) flags];
  };

  # hl.on(event, function() ... end)
  on = event: body: {
    _args = [event (lua "function()\n  ${body}\nend")];
  };

  # hl.env(name, value) — both plain strings, no Lua code involved
  env = name: value: {
    _args = [name value];
  };

  # hl.curve(name, spec)
  curve = name: spec: {
    _args = [name spec];
  };

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';

  # ---- "my programs" ----
  terminal = "kitty";
  fileManager = "dolphin";
  menu = "hyprlauncher";

  mainMod = "SUPER";

  # Reproduces the `for i = 1, 10 do ... end` loop: SUPER+[0-9] focuses a
  # workspace, SUPER+SHIFT+[0-9] moves the window there. 10 maps to key "0".
  workspaceBinds =
    lib.concatMap
    (i: let
      key =
        if i == 10
        then "0"
        else toString i;
    in [
      (bind "${mainMod} + ${key}" ''hl.dsp.focus({ workspace = ${toString i} })'')
      (bind "${mainMod} + SHIFT + ${key}" ''hl.dsp.window.move({ workspace = ${toString i} })'')
    ])
    (lib.range 1 10);
in {
  imports = [
    ./../programs/classic-hyprland-programs.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    # Set to `true` instead if you are NOT launching via UWSM.
    systemd.enable = false;

    settings = {
      #      ------------------------------------------------------------------
      #      -- Monitors
      #      ------------------------------------------------------------------
      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "1";
      };

      #      ------------------------------------------------------------------
      #      -- Autostart
      #      ------------------------------------------------------------------
      on = [
        (on "hyprland.start" (exec "waybar"))
      ];

      #      ------------------------------------------------------------------
      #      -- Environment variables
      #      ------------------------------------------------------------------
      env = [
        (env "XCURSOR_SIZE" "24")
        (env "HYPRCURSOR_SIZE" "24")
      ];

      #      ------------------------------------------------------------------
      #      -- Look and feel / layout / misc / input
      #      -- (each is its own hl.config({...}) call in the .lua, but they all
      #      -- write into the same top-level "config" table, so they're merged
      #      -- here into one attrset)
      #      ------------------------------------------------------------------
      config = {
        general = {
          gaps_in = 5;
          gaps_out = 20;

          border_size = 2;

          col = {
            active_border = {
              colors = ["rgba(33ccffee)" "rgba(00ff99ee)"];
              angle = 45;
            };
            inactive_border = "rgba(595959aa)";
          };

          resize_on_border = false;
          allow_tearing = false;

          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;

          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "0xee1a1a1a";
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
        };

        dwindle = {
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        scrolling = {
          fullscreen_on_one_column = true;
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = false;
        };

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 1;
          sensitivity = 0;

          touchpad = {
            natural_scroll = false;
          };

          natural_scroll = true;
        };
      };

      #      ------------------------------------------------------------------
      #      -- Animation curves & animations
      #      ------------------------------------------------------------------
      curve = [
        (curve "easeOutQuint" {
          type = "bezier";
          points = [[0.23 1] [0.32 1]];
        })
        (curve "easeInOutCubic" {
          type = "bezier";
          points = [[0.65 0.05] [0.36 1]];
        })
        (curve "linear" {
          type = "bezier";
          points = [[0 0] [1 1]];
        })
        (curve "almostLinear" {
          type = "bezier";
          points = [[0.5 0.5] [0.75 1]];
        })
        (curve "quick" {
          type = "bezier";
          points = [[0.15 0] [0.1 1]];
        })
        (curve "easy" {
          type = "spring";
          mass = 1;
          stiffness = 71.2633;
          dampening = 15.8273644;
        })
      ];

      animation = [
        {
          leaf = "global";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 5.39;
          bezier = "easeOutQuint";
        }
        {
          leaf = "windows";
          enabled = true;
          speed = 4.79;
          spring = "easy";
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 4.1;
          spring = "easy";
          style = "popin 87%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 1.49;
          bezier = "linear";
          style = "popin 87%";
        }
        {
          leaf = "fadeIn";
          enabled = true;
          speed = 1.73;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeOut";
          enabled = true;
          speed = 1.46;
          bezier = "almostLinear";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 3.03;
          bezier = "quick";
        }
        {
          leaf = "layers";
          enabled = true;
          speed = 3.81;
          bezier = "easeOutQuint";
        }
        {
          leaf = "layersIn";
          enabled = true;
          speed = 4;
          bezier = "easeOutQuint";
          style = "fade";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 1.5;
          bezier = "linear";
          style = "fade";
        }
        {
          leaf = "fadeLayersIn";
          enabled = true;
          speed = 1.79;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeLayersOut";
          enabled = true;
          speed = 1.39;
          bezier = "almostLinear";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 1.94;
          bezier = "almostLinear";
          style = "fade";
        }
        {
          leaf = "workspacesIn";
          enabled = true;
          speed = 1.21;
          bezier = "almostLinear";
          style = "fade";
        }
        {
          leaf = "workspacesOut";
          enabled = true;
          speed = 1.94;
          bezier = "almostLinear";
          style = "fade";
        }
        {
          leaf = "zoomFactor";
          enabled = true;
          speed = 7;
          bezier = "quick";
        }
      ];

      #      ------------------------------------------------------------------
      #      -- Input: gesture + per-device example
      #      ------------------------------------------------------------------
      gesture = {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      #      ------------------------------------------------------------------
      #      -- Keybindings
      #      ------------------------------------------------------------------
      bind =
        [
          (bind "${mainMod} + Q" (exec terminal))
          (bind "${mainMod} + C" "hl.dsp.window.close()")
          (bind "${mainMod} + M" (exec "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
          (bind "${mainMod} + E" (exec fileManager))
          (bind "${mainMod} + V" ''hl.dsp.window.float({ action = "toggle" })'')
          (bind "${mainMod} + R" (exec menu))
          (bind "${mainMod} + P" "hl.dsp.window.pseudo()")
          (bind "${mainMod} + J" ''hl.dsp.layout("togglesplit")'') # dwindle only

          # focus with mainMod + arrows
          (bind "${mainMod} + left" ''hl.dsp.focus({ direction = "left" })'')
          (bind "${mainMod} + right" ''hl.dsp.focus({ direction = "right" })'')
          (bind "${mainMod} + up" ''hl.dsp.focus({ direction = "up" })'')
          (bind "${mainMod} + down" ''hl.dsp.focus({ direction = "down" })'')
        ]
        ++ workspaceBinds
        ++ [
          # special workspace (scratchpad)
          (bind "${mainMod} + S" ''hl.dsp.workspace.toggle_special("magic")'')
          (bind "${mainMod} + SHIFT + S" ''hl.dsp.window.move({ workspace = "special:magic" })'')

          # scroll through workspaces
          (bind "${mainMod} + mouse_down" ''hl.dsp.focus({ workspace = "e+1" })'')
          (bind "${mainMod} + mouse_up" ''hl.dsp.focus({ workspace = "e-1" })'')

          # move/resize with mouse
          (bindFlags "${mainMod} + mouse:272" "hl.dsp.window.drag()" {mouse = true;})
          (bindFlags "${mainMod} + mouse:273" "hl.dsp.window.resize()" {mouse = true;})

          # multimedia keys
          (bindFlags "XF86AudioRaiseVolume" (exec "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") {
            locked = true;
            repeating = true;
          })
          (bindFlags "XF86AudioLowerVolume" (exec "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
            locked = true;
            repeating = true;
          })
          (bindFlags "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") {
            locked = true;
            repeating = true;
          })
          (bindFlags "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") {
            locked = true;
            repeating = true;
          })
          (bindFlags "XF86MonBrightnessUp" (exec "brightnessctl -e4 -n2 set 5%+") {
            locked = true;
            repeating = true;
          })
          (bindFlags "XF86MonBrightnessDown" (exec "brightnessctl -e4 -n2 set 5%-") {
            locked = true;
            repeating = true;
          })

          # playerctl (requires playerctl)
          (bindFlags "XF86AudioNext" (exec "playerctl next") {locked = true;})
          (bindFlags "XF86AudioPause" (exec "playerctl play-pause") {locked = true;})
          (bindFlags "XF86AudioPlay" (exec "playerctl play-pause") {locked = true;})
          (bindFlags "XF86AudioPrev" (exec "playerctl previous") {locked = true;})
        ];

      #      ------------------------------------------------------------------
      #      -- Window rules
      #      ------------------------------------------------------------------
      window_rule = [
        {
          name = "suppress-maximize-events";
          match.class = ".*";
          suppress_event = "maximize";
        }
        {
          name = "fix-xwayland-drags";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        }
        {
          name = "move-hyprland-run";
          match.class = "hyprland-run";
          move = "20 monitor_h-120";
          float = true;
        }
      ];
    };
  };
}
