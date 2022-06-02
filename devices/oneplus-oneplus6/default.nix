{ config, pkgs, lib, ... }:

let
  oneplus-sdm845-firmware = pkgs.callPackage ./firmware { };
in
{
  mobile.device.name = "oneplus-oneplus6";
  mobile.device.identity = {
    name = "Enchilada";
    manufacturer = "OnePlus";
  };
  mobile.hardware = {
    soc = "qualcomm-sdm845";
    ram = 1024 * 8;
    screen = {
      width = 1080; height = 2280;
    };
  };
  mobile.device.firmware = oneplus-sdm845-firmware;
  hardware.firmware = [ oneplus-sdm845-firmware ];
  mobile.quirks.qualcomm.msm-modem.enable = true;
  mobile.quirks.qualcomm.msm-modem.firmwareForPdMapper = oneplus-sdm845-firmware.forPdMapper;

  mobile.boot.stage-1 = {
    kernel.package = pkgs.callPackage ./kernel { };
    firmware = [ config.hardware.firmware ];
  };

  mobile.system.vendor.partition = "/dev/disk/by-partlabel/vendor_a";

  mobile.system.android.device_name = "enchilada";
  mobile.system.android = {
    # This device has an A/B partition scheme.
    ab_partitions = true;

    bootimg.flash = {
      offset_base = "0x00000000";
      offset_kernel = "0x00008000";
      offset_ramdisk = "0x01000000";
      offset_second = "0x00000000";
      offset_tags = "0x00000100";
      pagesize = "4096";
    };
  };

  boot.kernelParams = [
    # Extracted from an Android boot image
    "androidboot.hardware=qcom"
    "androidboot.console=ttyMSM0"
    #"video=vfb:640x400,bpp=32,memsize=3072000"
    "msm_rtb.filter=0x237"
    "ehci-hcd.park=3"
    "lpm_levels.sleep_disabled=1"
    "service_locator.enable=1"
    "swiotlb=2048"
    "androidboot.configfs=true"
    "loop.max_part=7"
    "androidboot.usbcontroller=a600000.dwc3"
    "buildvariant=user"
  ];

  mobile.system.type = "android";

  mobile.usb.mode = "gadgetfs";

  # Google
  mobile.usb.idVendor = "18D1";
  # "Nexus 4"
  mobile.usb.idProduct = "D001";

  mobile.usb.gadgetfs.functions = {
    adb = "ffs.adb";
    rndis = "rndis.usb0";
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT}=="1", SUBSYSTEMS=="input", ATTRS{name}=="pmi8998_haptics", TAG+="uaccess", ENV{FEEDBACKD_TYPE}="vibra"
  '';

}
