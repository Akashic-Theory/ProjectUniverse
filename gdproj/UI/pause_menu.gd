extends Control

@onready var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_key_input(event):
	if event.is_action_pressed("pause_game"):
		paused = !paused
		set_visible(paused)
		
		#TEMP saving settings file, move this to on settigs menu close
		if !paused:
			Game.save_settings()
