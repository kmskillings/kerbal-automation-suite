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

until false {
  set experimentIndex to 0.
  until experimentIndex > (shipExperiments:length - 1) {

    set shipExperiment to shipExperiments[0].
    
    // Check if the experiment is in a new situation.
    if shipExperimentsNewSituation[experimentIndex] {

      // If the experiment can be run,
      if (not shipExperiments[experimentIndex]:inoperable) and (not shipExperiments[experimentIndex]:hasData) {
        
        // Run the experiment.
        shipExperiments[experimentIndex]:deploy.
        
        // The experiment has been run in the new situation.
        set shipExperimentsNewSituation[experimentIndex] to false.

        print "Ran an experiment in a new situation.".
      }
    }

    // If the experiment has data ready,
    if shipExperiments[experimentIndex]:hasData {

      // If the data is worth transmitting,
      if shipExperiments[experimentIndex]:data[0]:transmitValue > 0 {
        // shipExperiment:transmit.
        print "Transmitted a science packet.".
      } else {
        shipExperiments[experimentIndex]:dump.
        // shipExperiment.reset.
        print "Dumped useless science packet.".
        wait 0.
      }
    }
    
    set experimentIndex to experimentIndex + 1.
  }

  wait 1.
}
