// Pitchover
// 
// This script contains a declaration for a function called pitchover. This
// script should be run before any mission operations which require this
// function.
//
// Executes a basic pitchover function. Holds the rocket vertical until it
// reaches a particular airspeed, then pitches over, keeping the nose within a
// certain angle of the prograde vector, until it reaches a particular pitch.
// Then, the nose is fixed to the prograde vector until the final booster stage
// burns out.
//
// Note that this script DOES NOT launch the rocket.

print "Loading function: pitchover".
declare global function pitchover {

  // The compass heading to launch toward
  declare parameter launchHeading.

  // The speed at which to begin pitching over
  declare parameter pitchoverSpeed.

  // The angle to which to force the rocket's nose
  declare parameter pitchoverAngle.

  // The angle between the rocket's prograde and heading shold never exceed
  // this amount during the pitchover process.
  declare parameter maxAngleOfAttack.

  // The pitchover function terminates after this stage burns out.
  declare parameter lastBoosterStage.

  // Whether or not to use RCS for steering during ascent.
  declare parameter useRcs.

  // How close two vectors should be to be considered the same.
  declare parameter closeEnough.

  // Staging logic
  lock stageEmpty to (stage:solidFuel = 0 and stage:liquidfuel = 0).
  lock boostComplete to (stageEmpty and stage:number <= lastBoosterStage).
  when
    stageEmpty and not boostComplete
  then {
    print "Staging.".
    stage.
    preserve.
  }

  // Max throttle on all engines.
  lock throttle to 1.

  // Enable RCS for maneuvering.
  if useRcs {
    rcs on.
  } else {
    rcs off.
  }

  // Go directly up during first phase.
  lock steering to ship:up.

  wait until ship:airspeed > pitchoverSpeed.
  print "Beginning pitchover maneuver.".
  lock angleProgradeUp to vectorAngle(ship:prograde:forevector, ship:up:forevector).
  lock steeringOffUp to min(pitchoverAngle, angleProgradeUp + maxAngleOfAttack).
  lock steering to heading(launchHeading, 90 - steeringOffUp).
  wait 1.

  // Wait until the prograde and facing directions are close.
  lock angleFacingPrograde to vectorAngle(ship:facing:forevector, ship:srfprograde:forevector).
  wait until angleFacingPrograde < closeEnough.
  print "Locking ship to prograde.".
  lock steering to ship:srfprograde.

  // Wait until the boost phase has finished.
  wait until boostComplete.
  print "Boost phase complete.".
  lock throttle to 0.
  unlock steering.
  
}