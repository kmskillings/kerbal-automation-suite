// Countdown
//
// This script contains a declaration for a function called countdown. This
// script should be run before any mission operations which require this
// function.
//
// Initiates a second-by-second countdown which can be interrupted by any key
// press.
//
// If the countdown is interrupted, the countdown function returns false.
// If the countdown finished, the countdown function returns true.

// This is kind of a hacky way to do it. If the user tries to interrupt the
// countdown, it won't be interrupted immediately. The countdown will only stop
// at "ticks." Using triggers would allow the user to interrupt the countdown
// anytime, but would require more engineering effort than I'm interested in
// right now.

print "Loading function countdown.".
declare global function countdown {

  declare parameter totalSeconds.
  print "Beginning countdown: " + totalSeconds + " seconds.".
  print "Press any key to interrupt.".

  // Clear any buffered input.
  terminal:input:clear().

  from {
    set remainingSeconds to countdownSeconds.
  } until remainingSeconds = 0
  step {
    set remainingSeconds to remainingSeconds - 1.
  } do {
    print remainingSeconds.
    wait 1.
    
    // Check if the user has interrupted the countdown after the waiting
    // period. This ensures the user can interrupt the countdown up until
    // the last moment.
    if terminal:input:hasChar() {
      return false.
    }
  }

  // The countdown terminated, so return true.
  return true.

}