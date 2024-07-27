// Deorbit
//
// This script contains a declaration for a function called deorbit. This
// script should be run before any mission operations which require this
// function.
//
// Executes a deorbit burn. Waits until the ship reaches apoapsis, then burns
// retrograde until the periapsis reaches a certain altitude.

print "Loading function: deorbit".
declare global function deorbit {

  // The deorbit burn will terminate after the periapsis reaches this altitude.
  parameter targetPeriapsis.

  // Wait until the spacecraft reaches apoapsis.
  wait until ship:orbit:eta:apoapsis < 20.
  kuniverse:timewarp:cancelwarp.

  // Orient for deorbit burn
  lock steering to ship:retrograde.

  // Deorbit burn
  lock throttle to 1.
  wait until ship:orbit:periapsis < targetPeriapsis.
  lock throttle to 0.
  unlock steering.

}