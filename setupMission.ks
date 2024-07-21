// Setup Mission
//
// Takes care of any simple housekeeping-type chores that need to happen at the
// very beginning of any mission.

// Open the terminal.
core:part:getmodule("kOSProcessor"):doevent("Open Terminal").

// Make sure that throttle goes to 0 after the program exits.
set ship:control:pilotmainthrottle to 0.