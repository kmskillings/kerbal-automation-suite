// Countdown
//
// Performs a countdown sequence prior to a rocket launch.

print "Press any key to proceed.".
terminal:input:getchar.

print "Proceeding with coundown. Ctrl-C to abort.".
from {
  set seconds to 3.
} until seconds = 0 
step {
  set seconds to seconds - 1.
} do {
  print seconds.
  wait 1.
}
print "Blastoff.".