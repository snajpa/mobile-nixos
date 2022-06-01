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
    rev = "f7ad1e5036bbb3d919960b54c0b3d51ab51dbf4d";
    sha256 = "sha256-zYYhBpgzTNhy+DZmnLW6IAR40c8ztFdhLRrwkgsgJ88=";
  };

  patches = [ ./drop-dangerous-android-options.patch ];

  makeImageDtbWith = "qcom/sdm845-oneplus-enchilada.dtb";
  isCompressed = "gz";
}
