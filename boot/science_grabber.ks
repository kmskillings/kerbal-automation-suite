// A simple script to help automate science collection tasks.

print "Beginning science_grabber.ks".

// Gets a list of science parts aboard the spacecraft.
set shipParts to SHIP:parts.
set shipExperiments to list().
set shipExperimentsNewSituation to list().
for shipPart in shipParts {
  if shipPart:hasmodule("ModuleScienceExperiment") {
    shipExperiments:add(shipPart:getmodule("ModuleScienceExperiment")).
    shipExperimentsNewSituation:add(true).
  }
}
print "Found science modules:".
print shipExperiments:length.

set kerbinAtmosphereHighAltitude  to 18_000.
set kerbinAtmosphereEdge          to 70_000.
set kerbinOrbitHighAltitude       to 250_000.

when ship:status = "FLYING" then {
  print "Ship took off. Marking new science available.".
  set newSituationIndex to 0.
  until newSituationIndex > (shipExperiments:length - 1) {
    set shipExperimentsNewSituation[newSituationIndex] to true.
    set newSituationIndex to newSituationIndex + 1.
  }
}

when ship:altitude > kerbinAtmosphereHighAltitude then {
  print "Ship reached high atmosphere. Marking new science available.".
  set newSituationIndex to 0.
  until newSituationIndex > (shipExperiments:length - 1) {
    set shipExperimentsNewSituation[newSituationIndex] to true.
    set newSituationIndex to newSituationIndex + 1.
  }
}

when ship:altitude > kerbinAtmosphereEdge then {
  print "Ship reached space. Marking new science available.".
  set newSituationIndex to 0.
  until newSituationIndex > (shipExperiments:length - 1) {
    set shipExperimentsNewSituation[newSituationIndex] to true.
    set newSituationIndex to newSituationIndex + 1.
  }
}

when ship:altitude > kerbinOrbitHighAltitude then {
  print "Ship reached high space. Marking new science available.".
  set newSituationIndex to 0.
  until newSituationIndex > (shipExperiments:length - 1) {
    set shipExperimentsNewSituation[newSituationIndex] to true.
    set newSituationIndex to newSituationIndex + 1.
  }
}

until false {
  set experimentIndex to 0.
  until experimentIndex > (shipExperiments:length - 1) {

    set shipExperiment to shipExperiments[experimentIndex].
    
    // Check if the experiment is in a new situation.
    if shipExperimentsNewSituation[experimentIndex] {

      // If the experiment can be run,
      if (not shipExperiment:inoperable) {

        // If the experiment has non-transmittable science data in it,
        if (shipExperiment:hasData and shipExperiment:data[0]:transmitValue = 0) {

          // Dump the data to make room for new data.
          shipExperiment:dump.
          // shipExperiment:reset.
          print "Dumped data to make room for new data: " + experimentIndex.
          wait 1.

        }
        
        // Run the experiment.
        print "Running experiment: " + experimentIndex.
        shipExperiment:deploy.
        wait 1.

        // If running the experiment made it inoperable,
        if shipExperiment:inoperable {

          // It can no longer run.
          set shipExperimentsNewSituation[experimentIndex] to false.

        }
      }
    }

    // If the experiment has data ready,
    if shipExperiments[experimentIndex]:hasData {

      // If the data is worth transmitting,
      if shipExperiment:data[0]:transmitValue > 0 {
        shipExperiment:transmit.
        print "Transmitted a science packet.".
      } else {

        // If the packet wasn't useful, don't run the experiment anymore.
        set shipExperimentsNewSituation[experimentIndex] to false.

      }
    }
    
    set experimentIndex to experimentIndex + 1.
  }

  wait 1.
}
