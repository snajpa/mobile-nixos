{ runCommand }:

firmware:

runCommand "${firmware.name}-xz" {} ''
  echo Aint compressing no firmware, baby
''
