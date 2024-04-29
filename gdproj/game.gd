extends Node

var is_paused = false

var settings: GameSettings

func _ready():
	# Load settings from file
	settings = load("res://saved_settings.tres") as GameSettings
	
	# If no settings file exists, create a new one
	if settings == null:
		print("No settings file found. Creating new one...")
		settings = GameSettings.new()
		save_settings()
	
	settings.request_viewport_change.connect(apply_viewport_change)
	
	settings.apply_graphics_from_saved()
	settings.bind_controls_from_saved()


## Called by settings resource to apply a graphics setting that it cannot apply itself
func apply_viewport_change(tag: String, value: Variant):
	print("applying viewport change...")
	# Because each setting needs to be treated differently, we need a match tree to set every setting
	match tag:
		"windowMode":
			get_viewport().mode = value + 2
		_:
			push_warning("Graphics setting '", tag, "' not fully implemented")


## Save settings to file
func save_settings():
	ResourceSaver.save(settings, "res://saved_settings.tres")
	print_verbose("Saved settings to 'saved_settings.tres'")
