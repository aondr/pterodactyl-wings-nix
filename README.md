# pterodactyl-wings-nix

**pterodactyl-wings-nix** provides a Nix package for Pterodactyl and Pelican wings, along with a NixOS module for fully declarative deployments.

## Packages Outputted

- **pterodactyl-wings**
- **pelican-wings**

## NixOS Module Documentation

<details>
<summary><strong>Module Options</strong></summary>

### enable
- **Type:** `Boolean`
- **Description:** Enable the Wings daemon.

### package
- **Type:** `Package`
- **Description:** The package to use for the Wings daemon.
- **Default:** `self.packages.${pkgs.stdenv.hostPlatform.system}.pterodactyl-wings`

### user
- **Type:** `String`
- **Description:** The user to run the Wings daemon as.
- **Default:** `pterodactyl`

### group
- **Type:** `String`
- **Description:** The group to run the Wings daemon as.
- **Default:** `pterodactyl`

### tokenFile
- **Type:** `Path or Null`
- **Description:** The file to store the Wings daemon token. This must be a path on the host and can be kept secure, for example, using agenix.
- **Default:** `null`

### configFile
- **Type:** `Path or Null`
- **Description:** Optional path to an existing Wings daemon configuration file.
- **Default:** `null`

### config
- **Type:** `Format or Null`
- **Description:** The declarative configuration for the Wings daemon.
- **Default:** `null`
- **Additional Info:** Refer to [Wings Configuration Options](https://github.com/pterodactyl/wings/blob/develop/config/config.go#L64-L329) for available settings.
  
</details>

## Example NixOS Module Usage

<details>
<summary><strong>Module Usage Example</strong></summary>

```nix
security.acme.certs."wings.example.com".group = config.services.wings.group;

services.wings = {
  enable = true;
  tokenFile = "/path/to/wings/token"; # Use a secure method like agenix to store this as a secret
  config = {
    uuid = "NODE-UUID-FROM-PANEL";
    token_id = "NODE-TOKEN-ID-FROM-PANEL";
    remote = "PANEL-URL";
    api = {
      host = "0.0.0.0";
      port = 8080;
      ssl = {
        enabled = true;
        cert = "/var/lib/acme/wings.example.com/fullchain.pem";
        key = "/var/lib/acme/wings.example.com/privkey.pem";
      };
    };
  };
};
```
</details>
