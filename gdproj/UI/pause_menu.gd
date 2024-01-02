extends Control

@onready var paused = false

func _unhandled_key_input(event):
	if event.is_action_pressed("pause_game"):
		paused = !paused
		set_visible(paused)
		
		#TEMP saving settings file, move this to on settings menu close
		if !paused:
			Game.save_settings()
