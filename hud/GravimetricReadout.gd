extends "res://hud/GravimetricReadout.gd"

export var new_system = "SYSTEM_RD_GR_SPECTROMETER_GRAVIMETRIC"

func configChanged(k = null, v = null):
	.configChanged(k, v)
	if not visible and ship:
		var installed = ship.getConfig(slot)
		visible = installed == system
		set_physics_process(visible)
