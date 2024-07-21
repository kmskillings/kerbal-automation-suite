// Echoes 1
//
// This is the bootloader and main mission script for the Echoes 1 mission,
// which was designed to retrieve science goo data from low space.

set countdownSeconds to 3.

set launchHeading     to 90.
set pitchoverSpeed    to 50.
set pitchoverAngle    to 5.
set maxAngleOfAttack  to 1.
set lastBoosterStage  to 3.
set useRcsDuringBoost to true.
set closeEnough       to 0.1.

set spaceAltitude to 70000.
set experimentsList to list(
  lexicon(
    "name",   "GooExperiment",
    "count",  2
  )
).

set parachuteAltitude to 5000.

// Does basic setup chores
runPath("0:/setupMission.ks").

// Prepares functions.
runOncePath("0:/functionDeclarations/countdown.ks").
runOncePath("0:/functionDeclarations/pitchover.ks").
runOncePath("0:/functionDeclarations/grabScienceAtAltitude.ks").
runOncePath("0:/functionDeclarations/recover.ks").

print "Echoes 1 program ready. Press any key to proceed.".
terminal:input:getchar().
print "Beginning Echoes 1 program sequence.".

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
  grabScienceAtAltitude(
    spaceAltitude,
    experimentsList
  ).
  recover(
    parachuteAltitude
  ).
} else {
  print "Countdown was interrupted.".
}

print "Echoes 1 program sequence complete!".
unlock throttle.
unlock steering.