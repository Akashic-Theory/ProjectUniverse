extends Control

func _unhandled_key_input(event):
	if event.is_action_pressed("pause_game"):
		Game.is_paused = !Game.is_paused
		set_visible(Game.is_paused)
		
		#TEMP saving settings file, move this to on settings menu close
		if !Game.is_paused:
			Game.save_settings()
			Game.settings.apply_graphics_from_saved()
			Game.settings.bind_controls_from_saved()
