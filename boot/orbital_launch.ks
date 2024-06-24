// A script for launching a rocket into a low (not neccessarily circular) orbit.

// The rocket flies straight up until the pitchover speed is reached. The
// rocket then pitches over to the pitchover angle. The rocket waits until its
// prograde vector matches the heading, then locks steering to the prograde
// vector until engine burnout.

// Next comes the coast phase. The rocket waits until the time-to-apoapsis
// reaches a certain value, then ignites the second stage engines. The second-
// stage engines burn until orbit is acheived.

// The pitchover speed, pitchover angle, and second-stage ignition time must
// be experimentally determined for each new rocket.

set pitchoverSpeed to 50.
set pitchoverAngle to 5.
set finalStageNum to 0.

set messageConfirmSettingsHeader  to "== Confirm Launch Settings ==".
set messagePitchoverSpeed         to "Pitchover speed:    ".
set messagePitchoverAngle         to "Pitchover angle:    ".
set messageFinalStageNum          to "Final stage number: ".

set closeEnough to 1.

// Log settings.
print messageConfirmSettingsHeader.
print messagePitchoverSpeed + pitchoverSpeed.
print messagePitchoverAngle + pitchoverAngle.
print messageFinalStageNum  + finalStageNum.

// Set up launch.

set initialStageNum to stage:number.

lock onLaunchPad          to (stage:number = initialStageNum).
lock directionOffPrograde to vectorAngle(ship:facing:forevector, ship:srfprograde:forevector).
lock stageEmpty           to (stage:solidFuel = 0 and stage:liquidfuel = 0).
lock boostComplete        to (stageEmpty and stage:number <= finalStageNum + 1).

// Set up staging logic.
when 
  stageEmpty and not boostComplete and not onLaunchPad
then {
  print "Staging.".
  stage.
  preserve.
} 

// Max throttle on all engines.
lock throttle to 1.

// Go directly up during first phase.
lock steering to ship:up.

print "Press any key to proceed.".
terminal:input:getchar.
print "Blastoff.".

stage.

wait until ship:airspeed > pitchoverSpeed.
lock steering to heading(0, 90) + R(0, -5, 0).
print "Beginning pitch program.".
wait 1.

// Wait until the prograde and facing directions are close.
wait until 
  directionOffPrograde < closeEnough.
print "Locking steering to prograde.".
lock steering to ship:srfPrograde.

wait until boostComplete.
print "Boost phase complete.".
lock throttle to 0.
stage.

// Calculate how much circularization burn will be needed.

// Determine speed at apoapsis. Use conservation of energy.
set potentialSpecificEnergyNow  to (ship:altitude * ship:body:mu / (ship:altitude + ship:body:radius)^2).
set kineticSpecificEnergyNow    to (ship:velocity:orbit:mag)^2 / 2.
set totalSpecificEnergy         to potentialSpecificEnergyNow + kineticSpecificEnergyNow.
set potentialSpecificEnergyApo  to (ship:orbit:apoapsis * ship:body:mu / (ship:altitude + ship:body:radius)^2).
set kineticSpecificEnergyApo    to totalSpecificEnergy - potentialSpecificEnergyApo.
set speedApo                    to sqrt(2*kineticSpecificEnergyApo).
print "Predicted speed at apoapsis: " + speedApo.

// Determine how long the circularization burn will have to be (at least).
set requiredOrbitalSpeed to sqrt(ship:body:mu / (ship:orbit:apoapsis + ship:body:radius)).
set circularizationDeltaV to requiredOrbitalSpeed - speedApo.
print "Circularization burn deltaV: " + circularizationDeltaV.

set circularizationAcceleration to ship:maxthrust / ship:mass.
set circularizationTime to circularizationDeltaV / circularizationAcceleration.
print "Circularization burn time: " + circularizationTime.
set circularizationApoTimeMinus to circularizationTime / 2.
print "Burn will begin at apoapsis T- " + circularizationApoTimeMinus.

wait until ship:orbit:eta:apoapsis < circularizationApoTimeMinus.
lock steering to ship:prograde.
lock throttle to 1.

wait until false.
