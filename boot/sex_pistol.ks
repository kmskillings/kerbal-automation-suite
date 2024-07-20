// Sex Pistol
//
// This script is the bootloader for the Sex Pistol series of orbital launch
// missions. As a bootloader, this script is responsible primarily for defining
// the paramters other scripts will use. It also begins the execution sequence
// of the launch scripts.

set scriptSequence to list(
  "countdown",
  "orbital_launch"
).

set launchPitchoverSpeed    to 40.
set launchPitchoverAngle    to 6.
set launchfinalStageNum     to 0.

runPath("0:/setup_mission.ks").