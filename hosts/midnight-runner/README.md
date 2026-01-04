# Midnight Runner Server Deployment

This directory contains the configuration for the midnight-runner host. This server uses nixos-anywhere for initial deployment and deploy-rs for ongoing updates.

## Prerequisites

1. A running server with SSH access (can be a fresh install with any Linux distro, or rescue mode)
2. Root access or a user with sudo privileges
3. SSH key authentication set up

**Note**: This configuration uses SSH port **50022** instead of the default port 22 for improved security.

## Disk Configuration

This host uses **disko** for declarative disk partitioning. The disk layout is defined in `disko.nix` and includes:
- BIOS boot partition (1M) for legacy BIOS compatibility
- EFI System Partition (512M) for UEFI boot
- Swap partition (4G) - adjust based on your server's RAM
- Root partition (remaining space) with ext4 filesystem

**IMPORTANT**: Before deployment, check the disk device name:
- Edit `disko.nix` and change `/dev/sda` to match your server's disk
- Common alternatives: `/dev/vda` (VPS), `/dev/nvme0n1` (NVMe), `/dev/sdb` (second disk)
- You can check the disk name by SSHing into the rescue system and running `lsblk`

## Initial Deployment with nixos-anywhere

nixos-anywhere allows you to install NixOS on a remote server over SSH, even if it's currently running a different operating system. It uses disko to automatically partition and format your disk.

### Step 1: Prepare SSH Access

Ensure you can SSH into your server (during initial deployment, use the default port 22):
```bash
ssh root@your-server-ip
```

If using a non-root user with sudo:
```bash
ssh your-user@your-server-ip
```

**Important**: During initial deployment via nixos-anywhere, the server will be on port 22. After NixOS is installed, SSH will move to port **50022**.

### Step 2: Configure SSH Keys (CRITICAL!)

**IMPORTANT**: You must add your SSH public key to the configuration before deployment, or you won't be able to log in!

Edit `hosts/midnight-runner/default.nix` and add your SSH key:
```nix
users.users.jfp = {
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAA... your-key-here"
  ];
};
```

To get your public key:
```bash
# If you have an SSH key already
cat ~/.ssh/id_ed25519.pub

# If you have a .pem file (common with cloud providers)
ssh-keygen -y -f /path/to/your/key.pem

# Generate a new key if needed
ssh-keygen -t ed25519 -C "your-email@example.com"
```

### Step 3: Update Deployment Hostname

Update the hostname in `flake.nix`:
- Find the `deploy.nodes.midnight-runner.hostname` line
- Replace with your actual server IP or hostname

### Step 4: Lock Flake Dependencies

```bash
# Lock dependencies for reproducible builds
nix flake lock
```

### Step 5: Verify Disk Configuration

Before deploying, verify the disk device name:
```bash
# SSH into the server
ssh root@your-server-ip

# Check available disks
lsblk

# Look for your main disk (usually sda, vda, or nvme0n1)
# Update hosts/midnight-runner/disko.nix with the correct device
```

### Step 6: (Optional) Test in VM First

Before deploying to your actual server, you can test the configuration in a VM:
```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake .#midnight-runner \
  --vm-test
```

This creates a local VM to verify your configuration works correctly without touching your real server.

### Step 7: Deploy with nixos-anywhere

Deploy to the server (this will **WIPE ALL DATA** on the target disk!):
```bash
# Standard deployment with root access:
nix run github:nix-community/nixos-anywhere -- \
  --flake .#midnight-runner \
  --target-host root@152.53.135.216

# If using a non-root user with sudo:
nix run github:nix-community/nixos-anywhere -- \
  --flake .#midnight-runner \
  --target-host your-user@152.53.135.216

# With password authentication (if key-based auth not set up):
SSHPASS='your-password' nix run github:nix-community/nixos-anywhere -- \
  --flake .#midnight-runner \
  --target-host root@152.53.135.216 \
  --env-password
```

The deployment will:
1. Connect via SSH
2. Boot NixOS installer via kexec (in RAM, no reboot needed)
3. Partition the disk according to `disko.nix`
4. Install NixOS with your configuration
5. Reboot into the new system

**Note**: The entire process usually takes 5-15 minutes depending on your internet speed.

### Step 8: Post-Installation

After nixos-anywhere completes:

1. The server will reboot into NixOS

2. **Remove old SSH host key** from your known_hosts:
   ```bash
   ssh-keygen -R 152.53.135.216
   ```

3. SSH into the server to verify (note the new port!):
   ```bash
   ssh -p 50022 jfp@152.53.135.216
   ```

4. Generate the age key for sops-nix:
   ```bash
   # On the server
   sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key
   ```

5. Add the age public key to `.sops.yaml` on your local machine

6. (Optional) Generate optimized hardware configuration with nixos-facter:
   ```bash
   # On your local machine, before first deploy
   nix run github:nix-community/nixos-anywhere -- \
     --flake .#midnight-runner \
     --target-host root@152.53.135.216 \
     --generate-hardware-config nixos-facter ./hosts/midnight-runner/hardware-configuration.nix
   ```

   This auto-generates a comprehensive hardware configuration with proper drivers, kernel modules, and firmware. The nixos-facter module provides better hardware detection than the standard `nixos-generate-config`.

## Ongoing Deployments with deploy-rs

After the initial nixos-anywhere deployment, use deploy-rs for all subsequent updates.

### Deploy System Updates

```bash
# Deploy to the midnight-runner server
nix run github:serokell/deploy-rs -- .#midnight-runner

# Or if you have deploy-rs installed:
deploy .#midnight-runner
```

**Note**: deploy-rs will automatically use the correct SSH port (50022) as configured in your flake.

### Deploy Specific Profile

```bash
deploy .#midnight-runner.system
```

### Deploy with Auto-Rollback

deploy-rs automatically rolls back if the deployment fails:
```bash
deploy .#midnight-runner --auto-rollback true --confirm-timeout 30
```

### Skip Checks (not recommended)

```bash
deploy .#midnight-runner --skip-checks
```

## Advanced Disk Configuration

### Using Different Filesystems

The default configuration uses ext4. You can switch to btrfs for snapshots and better data integrity:

```nix
# In disko.nix, change the root partition content to:
root = {
  size = "100%";
  content = {
    type = "btrfs";
    extraArgs = ["-f"]; # Force formatting
    subvolumes = {
      "/root" = {
        mountpoint = "/";
      };
      "/home" = {
        mountOptions = ["compress=zstd"];
        mountpoint = "/home";
      };
      "/nix" = {
        mountOptions = ["compress=zstd" "noatime"];
        mountpoint = "/nix";
      };
    };
  };
};
```

### Adjusting Swap Size

Edit the swap partition size in `disko.nix`:
```nix
swap = {
  size = "8G"; # Increase for more RAM or hibernation support
  content = {
    type = "swap";
    resumeDevice = true;
  };
};
```

### Multiple Disks

If your server has multiple disks, you can define additional disks in the disko configuration.

## Secrets Management

This host uses sops-nix for secrets. See the main repository README for details on managing secrets.

To create secrets for this host:
```bash
# Add secrets to the secrets file
sops hosts/midnight-runner/secrets/secrets.yml
```

## Troubleshooting

### nixos-anywhere fails to connect
- Ensure SSH is running on the target server
- During initial deployment, use port 22 (rescue system default)
- After deployment, SSH will be on port 50022
- Check firewall rules allow the appropriate SSH port
- Verify SSH key authentication works

### deploy-rs fails with "could not activate"
- Check the server logs: `journalctl -u nixos-activation`
- Verify the configuration builds locally: `nix build .#nixosConfigurations.midnight-runner.config.system.build.toplevel`

### Cannot SSH after deployment
- **Remember to use port 50022**: `ssh -p 50022 jfp@152.53.135.216`
- Check if the firewall is blocking port 50022
- Verify your SSH key is in the configuration
- Check the server console if available

## References

- [nixos-anywhere documentation](https://github.com/nix-community/nixos-anywhere)
- [deploy-rs documentation](https://github.com/serokell/deploy-rs)
- [disko (disk partitioning)](https://github.com/nix-community/disko)
