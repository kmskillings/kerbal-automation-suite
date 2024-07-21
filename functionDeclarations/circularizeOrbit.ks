// Pitchover
// 
// This script contains a declaration for a function called circularizeOrbit. 
// This script should be run before any mission operations which require this
// function.
//
// Executes a basic orbit circularization. The function calculates how long the
// engines will need to burn in order to circularize. The function then orients
// the craft and burns until the periapsis reaches a given altitude.
//
// Note that this function does not stage the rocket. Before the function is
// called, the ship should be on the appropriate stage.

print "Loading function: circularizeOrbit".
declare global function circularizeOrbit {

  // The circularization burn will terminate after the periapsis reaches this
  // altitude.
  parameter minPeriapsisAltitude.

  // The heading to circularize to (TODO: make this calculated on the fly).
  parameter burnHeading.

  // Determine speed at apoapsis using conservation of energy.
  set potentialEnergyNow  to -(ship:body:mu / (ship:altitude + ship:body:radius)).
  set kineticEnergyNow    to (ship:velocity:orbit:mag)^2 / 2.
  set totalEnergy         to potentialEnergyNow + kineticEnergyNow.
  print "Current potential energy: " + potentialEnergyNow.
  print "Current kinetic energy: " + kineticEnergyNow.
  print "Total energy: " + totalEnergy.
  set potentialEnergyApo  to -(ship:body:mu / (ship:orbit:apoapsis + ship:body:radius)).
  set kineticEnergyApo    to totalEnergy - potentialEnergyApo.
  set speedApo            to sqrt(2 * kineticEnergyApo).
  print "Apoapsis potential energy: " + potentialEnergyApo.
  print "Apoapsis kinetic energy: " + kineticEnergyApo.
  print "Predicted speed at apoapsis: " + speedApo.

  // Determine how long the circularization burn will have to be.
  set circularOrbitalSpeed to sqrt(ship:body:mu / (ship:orbit:apoapsis + ship:body:radius)).
  set burnDeltaV to circularOrbitalSpeed - speedApo.
  print "Circularization burn deltaV: " + burnDeltaV.
  set burnAcceleration to ship:maxthrust / ship:mass.
  set burnTime to burnDeltaV / burnAcceleration.
  print "Circularization burn time: " + burnTime.
  set burnApoTimeMinus to burnTime / 2.
  print "Burn will begin at apoapsis T- " + burnApoTimeMinus.

  // Calculate heading to burn toward.
  set burnPitch to 180-ship:orbit:trueanomaly.

  wait until ship:orbit:eta:apoapsis < burnApoTimeMinus.
  print "Burn heading: " + burnHeading.
  set burnSteering to heading(burnHeading, -burnPitch).
  lock steering to burnSteering.
  lock throttle to 1.
  wait until ship:orbit:periapsis > minPeriapsisAltitude.

  lock throttle to 0.
  unlock steering.
}