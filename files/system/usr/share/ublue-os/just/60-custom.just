install-nix:
  #!/usr/bin/env bash
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sudo bash -s -- install --no-confirm
  nix_systemd_file_location='/nix/var/nix/profiles/default'
  sudo rm -f /etc/systemd/system/nix-daemon.service
  sudo rm -f /etc/systemd/system/nix-daemon.socket
  sudo cp $nix_systemd_file_location/lib/systemd/system/nix-daemon.service /etc/systemd/system/nix-daemon.service
  sudo cp $nix_systemd_file_location/lib/systemd/system/nix-daemon.socket /etc/systemd/system/nix-daemon.socket

remove-nix:
  sudo /nix/nix-installer uninstall

install-bazzite-arch:
  #!/usr/bin/env bash
  distrobox-create --unshare-netns --nvidia --image ghcr.io/ublue-os/bazzite-arch --name bazzite-arch -Y
  distrobox-enter -n bazzite-arch -- distrobox-export --app steam
  distrobox-enter -n bazzite-arch -- distrobox-export --app lutris
  distrobox-enter -n bazzite-arch -- distrobox-export --app protontricks
  distrobox-enter -n bazzite-arch -- mkdir -p ~/.steam && distrobox-export --bin /usr/bin/steamcmd --export-path ~/.steam && mv ~/.steam/steamcmd ~/.steam/steamcmd.sh
