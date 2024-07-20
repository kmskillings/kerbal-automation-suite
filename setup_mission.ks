// Execute Script Sequence
//
// Sets up a mission according to parameters set by a preceding script. THis
// includes copying scripts to the craft's memory and executing them.

// Open the terminal
core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

print "Beginning script transfer.".

// Copy the script sequencing script.
copyPath("0:/execute_script_sequence.ks", "1:/execute_script_sequence.ks").

// Copy the mission scripts.
for scriptName in scriptSequence {
  set scriptPathArchive to "0:/" + scriptName + ".ks".
  set scriptPathLocal   to "1:/" + scriptName + ".ks".
  print "Copying script: " + scriptName.
  copyPath(scriptPathArchive, scriptPathLocal). 
}

print "Switching to onboard control.".
runPath("1:/execute_script_sequence.ks").