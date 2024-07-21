// Grab Science At Altitude
//
// This script contains a declaration for a function called 
// grabScienceAtAltitude. This script should be run before any mission
// operation which requires this function.
//
// Grabs certain science experiments when a certain altitude is reached.

print "Loading function: grabScienceAtAltitude".
declare global function grabScienceAtAltitude {
  
  // The altitude at which to grab the science
  declare parameter grabAltitude.

  // An array of "experiment" lexicons. An experiment lexicon consists of an
  // experimentName and a count. This script will attempt to run the number 
  // specified by the count of the experiment specified by the experiment's 
  // name.
  declare parameter experiments.

  print "Waiting until ship reaches " + grabAltitude + " to grab science.".
  wait until ship:altitude > grabAltitude.
  
  for experiment in experiments {

    print "Grabbing count " + experiment:count + " of experiment " + experiment:name.
    
    // The number of the specified experiment that has been run already.
    set alreadyRunCount to 0.

    // Finds all the parts on the ship with the experiment's name.
    set experimentParts to ship:partsNamed(experiment:name).

    // Loops through the experiment parts.
    for experimentPart in experimentParts {
      set experimentModule to experimentPart:getModule("ModuleScienceExperiment").
      if not experimentModule:inoperable {
        experimentModule:deploy.
        set alreadyRunCount to alreadyRunCount + 1.
        print "Grabbed data".
      }

      if alreadyRunCount = experiment.count {
        print "Completed grabbing data for experiment " + experiment:name.
        break.
      }
    }
  }
}