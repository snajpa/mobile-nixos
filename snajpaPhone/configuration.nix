{ config, lib, pkgs, ... }:

let
  inherit (lib) mkForce;
  system_type = config.mobile.system.type;

  defaultUserName = "snajpa";
in
{
config = {
  #imports = [
  #  (import <mobile-nixos/lib/configuration.nix> { device = "oneplus-oneplus6"; })
  #];

  system.stateVersion = "22.05";

  users.users."root".openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBK29/yHdxakVaJMYiIMBKb8nYGaj/gSQI4zErNVcbvsUpSiQuD+TLhIWYxR79D9rHFypMRm6aaEbeMHtw+TRjoI= snajpa@snajpaStation"
  ];
  users.users."${defaultUserName}" = {
    isNormalUser = true;
    password = "1234";
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBK29/yHdxakVaJMYiIMBKb8nYGaj/gSQI4zErNVcbvsUpSiQuD+TLhIWYxR79D9rHFypMRm6aaEbeMHtw+TRjoI= snajpa@snajpaStation"
    ];
  };
  security.sudo.extraRules = [
    { users = [ defaultUserName ];
      commands = [ { command = "ALL" ; options= [ "NOPASSWD" ]; } ];
    }
  ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  time.timeZone = "Europe/Prague";
  networking.hostName = "${defaultUserName}Phone";
  networking.firewall.enable = false;

  # iptables -t nat -A POSTROUTING -s 10.0.0.0/24 ! -d 10.0.0.0/24 -j MASQUERADE
  networking.interfaces.usb0.ipv4.addresses = [ { address = "10.0.0.1"; prefixLength = 24; } ];
  networking.defaultGateway.address = "10.0.0.2";
  networking.nameservers = [ "8.8.8.8" ];

  #nixos-rebuild -I /etc/nixos --builders 'ssh://build.snajpa.net aarch64-linux /root/.ssh/nix_remote 8 8 big-parallel' boot -j0
  nix.buildMachines = [ {
   hostName = "build.snajpa.net";
   system = "aarch64-linux";
   maxJobs = 8;
   speedFactor = 10;
   supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
   mandatoryFeatures = [ ];
  }] ;
  nix.distributedBuilds = true;
  nix.extraOptions = ''
        builders-use-substitutes = true
  '';


  environment.systemPackages = with pkgs; [
    kmod lshw pciutils usbutils
    ntp git gnumake vim
  #  firefox chromium
  ];

  #networking.networkmanager.unmanaged = [ "usb0" ];
  #services.xserver.enable = true;
  #services.xserver.displayManager = {
  #  gdm.enable = true;
  #  autoLogin.enable = true;
  #  autoLogin.user = defaultUserName;
  #  defaultSession = "phosh";
  #};
  #services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.desktopManager.phosh = {
  #  enable = true;
  #  user = defaultUserName;
  #  group = "users";
  #};
  #systemd.services.phosh.enable = false;

  #hardware.sensor.iio.enable = true;
  #programs.calls.enable = true;
};
}
