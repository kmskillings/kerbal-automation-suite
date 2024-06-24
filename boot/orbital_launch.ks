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

set pitchoverSpeed to 100.
set pitchoverAngle to 5.
set finalStageNum to 0.

set messageConfirmSettingsHeader  to "== Confirm Launch Settings ==".
set messagePitchoverSpeed         to "Pitchover speed:\t".
set messagePitchoverAngle         to "Pitchover angle:\t".
set messageFinalStageNum          to "Final stage number:\t".

set closeEnough to 1.

// Log settings.
print messageConfirmSettingsHeader.
print messagePitchoverSpeed + pitchoverSpeed.
print messagePitchoverAngle + pitchoverAngle.
print messageFinalStageNum  + finalStageNum.
print "".

// Set up launch.

lock directionOffPrograde to ship:facing * ship:prograde:inverse.

// Set up staging logic.
set initialStageNum to stage:number.
when 
  stage:solidFuel   < 0.1               and 
  stage:liquidfuel  < 0.1               and
  stage:number      > finalStageNum + 1 and
  stage:number      < initialStageNum   and
  stage:ready
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
terminal:getchar.

stage.

wait until ship:airspeed > pitchoverSpeed.
lock steering to ship:up + R(pitchoverAngle, 0, 0).

// Wait until the prograde and facing directions are close.
wait until 
  sqrt(
    directionOffPrograde.pitch * directionOffPrograde:pitch + 
    directionOffPrograde:yaw * directionOffPrograde
  ) < closeEnough.
lock steering to ship:srfPrograde.
