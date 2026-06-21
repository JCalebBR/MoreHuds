extends "res://hud/AutopilotOverlay.gd"

export var new_autopilot = "SYSTEM_AUTOPILOT_GR27"

func processBusyAutopilotFunctions(delta: float):
	busy.lock()
	var colwar = false
	var boresight = false
	var ai = false
	match autopilotType:
		"SYSTEM_AUTOPILOT_MK3":
			colwar = true
			boresight = true
		"SYSTEM_AUTOPILOT_MK4":
			ai = true
		new_autopilot:
			colwar = true
	if ship.forceHudFeature.get("boresight", false):
		boresight = true
	contrast = ship.forceHudFeature.get("contrast", contrast)
		
	if ai and Tool.claim(ship):
		aiPaths = ship.aiPaths
		prepareAiAwareness(delta)
		prepareAiSpikes(delta)
		Tool.release(ship)

	if colwar and Tool.claim(ship):
		if ship.isPlayerControlled():
			hitWarning = ship.getPendingCollision(20000)
		else:
			hitWarning = null
		Tool.release(ship)
	else:
		hitWarning = null
		
	if boresight and Tool.claim(ship):
		if ship.isPlayerControlled() or ship.forceHud:
			boresightShapes = ship.getBoresightShapes()
		else:
			boresightShapes = []
		Tool.release(ship)
	else:
		boresightShapes = []
		
	busy.unlock()
