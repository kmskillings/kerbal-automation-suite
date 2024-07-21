// Sex Pistol
//
// This script is the bootloader for the Sex Pistol series of orbital launch
// missions. As a bootloader, this script is responsible primarily for defining
// the paramters other scripts will use. It also begins the execution sequence
// of the launch scripts.

set countdownSeconds to 3.

set launchHeading     to 90.
set pitchoverSpeed    to 40.
set pitchoverAngle    to 6.
set maxAngleOfAttack  to 1.
set lastBoosterStage  to 1.
set useRcsDuringBoost to true.
set closeEnough       to 0.1.

// Does basic setup chores
runPath("0:/setupMission.ks").

// Prepares functions.
runOncePath("0:/functionDeclarations/countdown.ks").
runOncePath("0:/functionDeclarations/pitchover.ks").

print "Sex Pistol program ready. Press any key to proceed.".
terminal:input:getchar().
print "Beginning Sex Pistol program sequence.".

set countdownTerminated to countdown(countdownSeconds).
if countdownTerminated {
  print "Blastoff!".
  stage.
  pitchover(
    launchHeading,
    pitchoverSpeed,
    pitchoverAngle,
    maxAngleOfAttack,
    lastBoosterStage,
    useRcsDuringBoost,
    closeEnough
  ).
} else {
  print "Countdown was interrupted.".
}

print "Sex Pistol program sequence complete!".