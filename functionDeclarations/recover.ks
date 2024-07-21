// Recover
//
// This script contains a declaration for a function called Recover. This
// script should be run before any mission operation which requires this
// function.
//
// Recovers the vessel, including orienting the craft for reentry and deploying
// parachutes (via staging). Does not burn for reentry.
//
// This function assumes that the craft's parachutes are on the next stage in
// the staging sequence at whatever time this function is called.

print "Loading function: recover".
declare global function recover {
  
  // The altitude at which to deploy the parachutes
  declare parameter parachuteAltitude.

  print "Orienting for reentry.".
  lock steering to ship:srfretrograde.

  print "Waiting for parachute deployment at " + parachuteAltitude.
  wait until ship:altitude < parachuteAltitude.
  unlock steering.
  stage.
  print "Deployed parachutes.".

}