# NixOS

## Installation
- Disable secure boot
- Setup WiFi
- Download and run `install.sh`
  ```sh
  curl -sSL https://raw.githubusercontent.com/JenSeReal/NixOS/main/bootstrap/install.sh -o install.sh; sh install.sh
  ```
- Adapt `/mnt/etc/nixos/hardware-configuration.nix` with `hardware-configuration.nix`
- Install NixOS with `sudo nixos-install`
- Reboot
- Login as root
- Set password for default user
  ```sh
  passwd USER
  ```
- Logout
- Login as default user
- Begin installing flakes and use the git repository

## Configuration
- `git clone git@github.com:JenSeReal/NixOS.git`
- `sudo nix run nixpkgs#sbctl create-keys`
- `sudo nixos-rebuild switch --flake .`
- Reboot
- Enable secure boot
  - Select "Administer Secure Boot"
  - Select "Erease all Secure Boot Settings"
- `sudo sbctl enroll-keys --microsoft`
- `systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/<my encrypted device>`

## Secrets
- Create new sops file `nix-shell -p sops --run "sops systems/shared/secrets/wifi.yml"`
- SSH to age key `sudo nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt"`
- Age public key from age key `nix-shell -p age --run "age-keygen -y ~/.config/sops/age/keys.txt"`

# MacOS
- Run Nix installer `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`
- Install nix-darwin `nix run nix-darwin -- switch --flake .`
- Afterwards `darwin-rebuild switch --flake .`