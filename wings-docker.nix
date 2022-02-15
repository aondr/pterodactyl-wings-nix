{ lib
, dockerConfig
, dockerTools
, bash
, cacert
, coreutils
, dumb-init
, iana-etc
, runCommandNoCC
, shadow
, symlinkCACerts
, setupFHSScript
, shadowLib
, tzdata
, pterodactyl-wings
}:

let
  wingsUid = 998;
  wingsGid = 998;
  wingsUser = "pterodactyl";

  users = shadowLib.defaultUsers // {
    "${wingsUser}" = {
      uid = 998;
    };
  };

  groups = shadowLib.defaultGroups // {
    "${wingsUser}" = {
      gid = 998;
    };
  };

  inherit (shadowLib) setupUsers setupUsersScript;
in
dockerTools.buildImage {
  name = "pterodactyl-wings";
  config = {
    Env = dockerConfig.env {
      TZDIR = "/etc/zoneinfo";
      TZ = "UTC";
      WINGS_UID = toString users.${wingsUser}.uid;
      WINGS_GID = toString groups.${wingsUser}.gid;
      WINGS_USERNAME = wingsUser;
    };
    Volumes = dockerConfig.volumes [
      "/var/lib/pterodactyl"
      "/var/log/pterodactyl"
    ];
    Entrypoint = [ "/usr/bin/dumb-init" "--" ];
    Cmd = [ "/usr/bin/wings" "--config" "/etc/pterodactyl/config.yml" ];
  };

  contents = [
    dockerTools.usrBinEnv
    (runCommandNoCC "wings-base" ((setupUsers { inherit users groups; }) // {
      allowSubstitutes = false;
      preferLocalBuild = true;
    }) ''
      for d in bin sbin usr/bin usr/lib var/lib/pterodactyl var/log/pterodactyl; do
        mkdir -p $out/$d
      done

      ${symlinkCACerts { inherit cacert; targetDir = "$out"; }}
      ${setupUsersScript { }}

      ln -s ${bash}/bin/bash $out/bin/sh
      ln -s ${bash}/bin/bash $out/bin/bash
      ln -s ${dumb-init}/bin/dumb-init $out/usr/bin/dumb-init
      ln -s ${pterodactyl-wings}/bin/wings $out/usr/bin/wings

      ln -s etc/zoneinfo/UTC $out/etc/localtime
      echo "ID=distroless" > $out/usr/lib/os-release # Will no-op user creation
      ln -s usr/lib/os-release $out/etc/os-release
      ln -s ${iana-etc}/etc/protocols $out/etc/protocols
      ln -s ${iana-etc}/etc/services $out/etc/services
      ln -s ${tzdata}/share/zoneinfo $out/etc/zoneinfo
    '')
  ];
}
