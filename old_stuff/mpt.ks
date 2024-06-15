//A simple script that takes care of the 'suicide box' stage of early Moon missions.
//Waits until a previously made maneuver node is 9 seconds away.
//It then stages, waits 6 seconds, stages, waits, and stages one last time.

SET X TO ALLNODES[0].
PRINT "Acquired node:".
PRINT X:ETA.

WAIT UNTIL X:ETA < 9.
STAGE.
WAIT 6.
STAGE.
WAIT 6.
STAGE.