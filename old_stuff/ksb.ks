CLEARSCREEN.

WHEN STAGE:LIQUIDFUEL < 0.1 THEN {
	STAGE.
	PRESERVE.
}

PRINT "Welcome to Kerbin Space Bouy autopilot. Engaging.".

//Fires engines prograde to raise apoapsis
LOCK STEERING TO SHIP:PROGRADE.
PRINT "Orienting".
LOCK THROTTLE TO 1.
WAIT 3.
WAIT UNTIL SHIP:OBT:APOAPSIS > 2800000. //gets apoapsis up to kerbosync-ish
LOCK THROTTLE TO 0.05. //sets throttle for trimming
WAIT UNTIL SHIP:OBT:APOAPSIS > 2863330. //trims it finely
LOCK THROTTLE TO 0.
PRINT "Apoapsis set. Waiting until circularization.".

//circularizes at orbit
WAIT UNTIL ETA:APOAPSIS  < 2.
PRINT "Apoapsis reached. Cicularizing.".
LOCK THROTTLE TO 1.
WAIT UNTIL SHIP:OBT:PERIOD > 21400.
LOCK THROTTLE TO 0.05.
WAIT UNTIL SHIP:OBT:PERIOD > 21549.
LOCK THROTTLE TO 0.
PRINT "Welcome to orbit. Returning manual command.".