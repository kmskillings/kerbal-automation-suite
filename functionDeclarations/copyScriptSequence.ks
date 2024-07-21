// Copy Script Sequence
//
// This script contains a declaration for a function called CopyScriptSequence.
// This script should be run before any mission operations which require this
// function.
//
// In the context of this system, a mission consists of a number of scripts run
// sequentially on a single core. This function prepares for a mission or 
// mission phase by copying each script in the sequence to the core.
//
// The list of sequences to transfer is passed in by the parameter
// scriptSequence.
//
// The function signals whether the entire sequence was transferred by 


declare global function copyScriptSequence {
  
}

parameter scriptSequence.

// Open the terminal


print "Beginning script transfer.".

// Copy the script sequencing script.
// copyPath("0:/execute_script_sequence.ks", "1:/execute_script_sequence.ks").

// Copy the mission scripts.
for scriptName in scriptSequence {

  // Deterine whether the script exists in the archive.
  switch to 0.
  if not core:currentvolume:exists(scriptName) {

  }


  set scriptPathArchive to "0:/" + scriptName + ".ks".
  set scriptPathLocal   to "1:/" + scriptName + ".ks".
  print "Copying script: " + scriptName.
  copyPath(scriptPathArchive, scriptPathLocal). 
}

print "Script sequence successfully transferred.".