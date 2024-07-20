// Execute Script Sequence
//
// Executes a sequence of scripts in order to conduct a mission.
// The sequence of scripts to execute should be placed in a global variable
// called scriptSequence.

// Execute the scripts in sequence.
print "Beginning script sequence execution.".
for scriptName in scriptSequence {
  set scriptPathLocal to "1:/" + scriptName + ".ks".
  print "Executing script: " + scriptPathLocal.
  runPath(scriptPathLocal).
}

print "Reached end of script sequence. Returning manual control.".