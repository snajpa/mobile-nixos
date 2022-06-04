{
  mobile-nixos
, fetchFromGitLab
, pkgs
, ...
}:
with pkgs;
mobile-nixos.kernel-builder {
  version = "5.18.0-postmarketos-qcom-sdm845";
  configfile = ./config.aarch64;

  src = fetchFromGitLab {
    owner = "sdm845-mainline";
    repo = "linux";
    rev = "5e399e72d48a00d02836169b8a78982932de0433";
    sha256 = "sha256-sD3R6AS6QxuGZ3B4A+2mtnZANifkntkAa53LgGw4PjA=";
  };

  patches = [ ./drop-dangerous-android-options.patch ];

  makeImageDtbWith = "qcom/sdm845-oneplus-enchilada.dtb";
  isCompressed = "gz";
}
