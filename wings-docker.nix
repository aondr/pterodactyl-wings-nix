{ lib
, dockerConfig
, dockerTools
, bash
, cacert
, coreutils
, dumb-init
, iana-etc
, shadow
, shadowSetup
, tzdata
, pterodactyl-wings
}:

let
  wingsUid = "998";
  wingsGid = "998";
  wingsUser = "pterodactyl";
in
dockerTools.buildImage {
  name = "pterodactyl-wings";
  config = {
    Env = dockerConfig.env {
      TZDIR = "/etc/zoneinfo";
      TZ = "UTC";
      WINGS_UID = wingsUid;
      WINGS_GID = wingsGid;
      WINGS_USERNAME = wingsUser;
    };
    Volumes = dockerConfig.volumes [
      "/var/lib/pterodactyl"
      "/var/log/pterodactyl"
    ];
    Entrypoint = [ "/usr/bin/dumb-init" "--" ];
    Cmd = [ "/usr/bin/wings" "--config" "/etc/pterodactyl/config.yml" ];
  };

  extraCommands = ''
    mkdir -p bin etc/ssl/certs etc/pki/tls/certs sbin usr/bin usr/lib var/lib/pterodactyl var/log/pterodactyl
    ln -s ${bash}/bin/bash bin/sh
    ln -s ${coreutils}/bin/env usr/bin/env
    ln -s ${dumb-init}/bin/dumb-init usr/bin/dumb-init
    ln -s ${pterodactyl-wings}/bin/wings usr/bin/wings
    ln -s ${shadow}/bin/nologin sbin/nologin
    ln -s ${tzdata}/share/zoneinfo etc/zoneinfo
    ln -s etc/zoneinfo/UTC etc/localtime
    echo "ID=distroless" > usr/lib/os-release # Will no-op user creation
    ln -s usr/lib/os-release etc/os-release
    ln -s ${iana-etc}/etc/protocols etc/protocols
    ln -s ${iana-etc}/etc/services etc/services
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt etc/ssl/certs/ca-bundle.crt
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt etc/ssl/certs/ca-certificates.crt
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt etc/pki/tls/certs/ca-bundle.crt
    ln -s ${cacert.p11kit}/etc/ssl/trust-source etc/ssl/trust-source

    ${shadowSetup { runtimeShell = "/bin/sh"; }}
    echo "${wingsUser}:x:${wingsUid}:${wingsGid}::/:/sbin/nologin" >> etc/passwd
    echo "${wingsUser}:x:${wingsGid}:" >> etc/group
    echo "${wingsUser}:x::" >> etc/gshadow
  '';
}
