extends Node

# Set mod priority if you want it to load before/after other mods
# Mods are loaded from lowest to highest priority, default is 0
const MOD_PRIORITY = -99
# Name of the mod, used for writing to the logs
const MOD_NAME = "Ganymede Runners' Aftermarket Huds"
const MOD_VERSION_MAJOR = 0
const MOD_VERSION_MINOR = 3
const MOD_VERSION_BUGFIX = 0
const MOD_VERSION_METADATA = ""
# Path of the mod folder, automatically generated on runtime
var modPath:String = get_script().resource_path.get_base_dir() + "/"
# Required var for the replaceScene() func to work
var _savedObjects := []

var modSettings = {}

var ADD_EQUIPMENT_ITEMS = []

var verbose = true

func _init(modLoader = ModLoader):
	l("Initialising", MOD_NAME)
	loadDLC()
	
	replaceScene("hud/Hud.tscn")
	
	installScriptExtension("hud/ShowWhenSystemInstalled.gd")
	installScriptExtension("hud/components/GravimetricScale.gd")
	installScriptExtension("hud/GravimetricReadout.gd")
	installScriptExtension("hud/AutopilotOverlay.gd")
	installScriptExtension("ships/ship-ctrl.gd")

	
	l("Initialised!", MOD_NAME)

func _ready():
	l("Ready!")

# Helper function to extend scripts
# Loads the script you pass, checks what script is extended, and overrides it
func installScriptExtension(path:String):
	var childPath:String = str(modPath + path)
	var childScript:Script = load(childPath)

	childScript.new()

	var parentScript:Script = childScript.get_base_script()
	var parentPath:String = parentScript.resource_path

	l("Installing script extension: %s <- %s" % [parentPath, childPath])

	childScript.take_over_path(parentPath)


# Helper function to replace scenes
# Can either be passed a single path, or two paths
# With a single path, it will replace the vanilla scene in the same relative position
func replaceScene(newPath:String, oldPath:String = ""):
	l("Updating scene: %s" % newPath)

	if oldPath.empty():
		oldPath = str("res://" + newPath)

		newPath = str(modPath + newPath)

		var scene := load(newPath)
		scene.take_over_path(oldPath)
		_savedObjects.append(scene)
		l("Finished updating: %s" % oldPath)


# Instances Settings.gd, loads DLC, then frees the script.
func loadDLC():
	l("Preloading DLC as workaround")
	var DLCLoader:Settings = preload("res://Settings.gd").new()
	DLCLoader.loadDLC()
	DLCLoader.queue_free()
	l("Finished loading DLC")


# Func to print messages to the logs
func l(msg:String, title:String = MOD_NAME, version:String = str(MOD_VERSION_MAJOR) + "." + str(MOD_VERSION_MINOR) + "." + str(MOD_VERSION_BUGFIX)):
	if not MOD_VERSION_METADATA == "":
		version = version + "-" + MOD_VERSION_METADATA
	Debug.l("[%s V%s]: %s" % [title, version, msg])
