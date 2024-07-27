// Echoes 4
//
// This is the bootloader and main mission script for the Echoes 4 mission,
// which was deseigned to orbit Kerbin, retrieve scientific data, then reenter
// and return to the surface for recovery.

set countdownSeconds to 3.

set launchHeading     to 90.
set pitchoverSpeed    to 20.
set pitchoverAngle    to 8.
set maxAngleOfAttack  to 1.
set lastBoosterStage  to 4.
set useRcsDuringBoost to true.
set closeEnough       to 0.1.

set spaceAltitude to 70100.
set targetApoAltitude to 75000.
set experimentsList to list(
  lexicon(
    "name",   "sensorThermometer",
    "count",  1
  ),
  lexicon(
    "name",   "sensorBarometer",
    "count",  1
  )
).

set orbitCount to 10.

set deorbitPeriapsis to 20000.

set parachuteAltitude to 5000.

runPath("0:/setupMission.ks").

runOncePath("0:/functionDeclarations/countdown.ks").
runOncePath("0:/functionDeclarations/pitchover.ks").
runOncePath("0:/functionDeclarations/circularizeOrbit.ks").
runOncePath("0:/functionDeclarations/grabScienceAtAltitude.ks").
runOncePath("0:/functionDeclarations/deorbit.ks").
runOncePath("0:/functionDeclarations/recover.ks").

print "Echoes 4 program ready. Press any key to proceed.".
terminal:input:getchar().
print "Beginning Echoes 4 program sequence.".

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

  // After the booster burns out, the apoapse probably won't be where it needs
  // to be. Burn the sustainer stage until it reaches the apoapsis altitude.
  lock throttle to 0.
  stage.
  lock steering to ship:prograde.
  lock throttle to 1.
  wait until ship:apoapsis > targetApoAltitude.
  lock throttle to 0.
  
  circularizeOrbit(
    spaceAltitude,
    launchHeading
  ).

  grabScienceAtAltitude(
    spaceAltitude,
    experimentsList
  ).

  wait orbitCount * ship:orbit:period.

  deorbit(
    deorbitPeriapsis
  ).

  wait until altitude < spaceAltitude.
  stage.

  recover(
    parachuteAltitude
  ).

}