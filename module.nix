self: {
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.wings;

  format = pkgs.formats.yaml {};
  generatedConfig = format.generate "config.yml" cfg.config;
in {
  options.services.wings = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable the Pterodactyl Wings daemon");
    package = lib.mkOption {
      type = lib.types.package;
      description = lib.mdDoc "The package to use for the Pterodactyl Wings daemon";
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.pterodactyl-wings;
    };
    user = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc "The user to run the Pterodactyl Wings daemon as";
      default = "wings";
    };
    group = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc "The group to run the Pterodactyl Wings daemon as";
      default = "wings";
    };
    tokenFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = lib.mdDoc "The file to store the Pterodactyl Wings daemon token in";
    };
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = lib.mdDoc "The path to the Pterodactyl Wings daemon configuration file";
      default = null;
    };
    config = lib.mkOption {
      type = lib.types.nullOr format.type;
      default = null;
      description = lib.mdDoc ''
        The configuration for the Pterodactyl Wings daemon
        Refer to <https://github.com/pterodactyl/wings/blob/develop/config/config.go#L64-L329> for all available options
      ''; # Pterodactyl doesn't seem to have any documentation on the configuration options
    };
  };
  config = lib.mkIf cfg.enable {
    warnings =
      []
      ++ lib.optional (cfg.config != null && cfg.config ? token && cfg.config.token != null)
      ''
        services.wings: Providing the Wings token in config.token is insecure and will be made word-readable in the Nix store.
      ''
      ++ lib.optional (!config.virtualisation.docker.enable && !config.virtualisation.podman.enable)
      ''
        services.wings: Neither Docker nor Podman is enabled on this system. Pterodactyl Wings requires a container runtime to function properly.
      '';
    assertions = [
      {
        assertion = cfg.config != null || cfg.configFile != null;
        message = "services.wings.config or services.wings.configFile must be set when services.wings.enable";
      }
    ];

    users.users = lib.optionalAttrs (cfg.user == "wings") {
      wings = {
        name = "wings";
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == "wings") {
      wings = {
        name = "wings";
      };
    };

    # Should this only be applied based on an option? Check cfg.config if these directories exist or are default?
    systemd.tmpfiles.rules = [
      "d /var/log/pterodactyl 0700 ${cfg.user} ${cfg.group}"
      "d /var/lib/pterodactyl 0700 ${cfg.user} ${cfg.group}"
    ];

    systemd.services.wings = {
      description = "The server control plane for Pterodactyl Panel. Written from the ground-up with security, speed, and stability in mind.";
      wantedBy = ["multi-user.target"];
      preStart = lib.mkIf (cfg.tokenFile != null) ''

        mkdir -p /etc/pterodactyl

        token=$(cat ${cfg.tokenFile})

        cat > /etc/pterodactyl/config.yml << EOF

        token: $token

        ${builtins.readFile generatedConfig}

        EOF

               chown ${cfg.user}:${cfg.group} /etc/pterodactyl/config.yml

        exit 0
      ''; # Jank stuff to write the token to the config file before starting the service
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/wings --config ${
          if cfg.tokenFile != null
          then "/etc/pterodactyl/config.yml"
          else if cfg.configFile != null
          then cfg.configFile
          else generatedConfig
        }";
        Restart = "on-failure";
        #TODO: Harden the service? Is it needed since this interacts with docker/podman?
      };
    };
  };
}
