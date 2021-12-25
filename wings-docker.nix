{ lib
, dockerTools
, bash
, cacert
, coreutils
, dumb-init
, iana-etc
, shadow
, tzdata
, pterodactyl-wings
}:

let
  shadowSetupNoRoot = ''
    mkdir -p etc/pam.d
    if [[ ! -f etc/passwd ]]; then
      echo "root:x:0:0::/root:/bin/sh" > etc/passwd
      echo "root:!x:::::::" > etc/shadow
    fi
    if [[ ! -f etc/group ]]; then
      echo "root:x:0:" > etc/group
      echo "root:x::" > etc/gshadow
    fi
    if [[ ! -f etc/pam.d/other ]]; then
      cat > etc/pam.d/other <<EOF
    account sufficient pam_unix.so
    auth sufficient pam_rootok.so
    password requisite pam_unix.so nullok sha512
    session required pam_unix.so
    EOF
    fi
    if [[ ! -f etc/login.defs ]]; then
      touch etc/login.defs
    fi
  '';

  wingsUid = "998";
  wingsGid = "998";
  wingsUser = "pterodactyl";
in
dockerTools.buildImage {
  name = "pterodactyl-wings";
  config = {
    Env = lib.mapAttrsToList (k: v: "${k}=${toString v}") {
      TZDIR = "/etc/zoneinfo";
      TZ = "UTC";
      WINGS_UID = wingsUid;
      WINGS_GID = wingsGid;
      WINGS_USERNAME = wingsUser;
    };
    Volumes = lib.listToAttrs (map (p: { name = p; value = { }; }) [
      "/var/log/pterodactyl"
    ]);
    Entrypoint = [ "/usr/bin/dumb-init" "--" ];
    Cmd = [ "/usr/bin/wings" "--config" "/etc/pterodactyl/config.yml" ];
  };

  extraCommands = ''
    mkdir -p bin etc/ssl/certs etc/pki/tls/certs sbin usr/bin usr/lib var/log/pterodactyl
    ln -s ${bash}/bin/bash bin/sh
    ln -s ${coreutils}/bin/env usr/bin/env
    ln -s ${dumb-init}/bin/dumb-init usr/bin/dumb-init
    ln -s ${pterodactyl-wings}/bin/wings usr/bin/wings
    ln -s ${shadow}/bin/nologin sbin/nologin
    ln -s ${tzdata} etc/zoneinfo
    ln -s etc/zoneinfo/UTC etc/localtime
    echo "ID=distroless" > usr/lib/os-release # Will no-op user creation
    ln -s usr/lib/os-release etc/os-release
    ln -s ${iana-etc}/etc/protocols etc/protocols
    ln -s ${iana-etc}/etc/services etc/services
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt etc/ssl/certs/ca-bundle.crt
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt etc/ssl/certs/ca-certificates.crt
    ln -s ${cacert}/etc/ssl/certs/ca-bundle.crt etc/pki/tls/certs/ca-bundle.crt
    ln -s ${cacert.p11kit}/etc/ssl/trust-source etc/ssl/trust-source

    ${shadowSetupNoRoot}
    echo "${wingsUser}:x:${wingsUid}:${wingsGid}::/:/sbin/nologin" >> etc/passwd
    echo "${wingsUser}:x:${wingsGid}:" >> etc/group
    echo "${wingsUser}:x::" >> etc/gshadow
  '';
}
