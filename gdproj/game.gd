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
	else:
		settings.bind_controls_from_file()


## Save settings to file
func save_settings():
	ResourceSaver.save(settings, "res://saved_settings.tres")
	print_verbose("Saved settings to 'saved_settings.tres'")
