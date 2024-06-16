// A simple script that stages whenever the last stage burns out.
// Checks for only solid fuel.

print "Listening for stage command to start.".

set startingStage to ship:stageNum.

wait until ship:stageNum <> startingStage.
print "Beginning staging program".

when stage:solidFuel < 0.01 and stage:number <> 0 then {
  print "Staging.".
  stage.
  preserve.
}

wait until false.

