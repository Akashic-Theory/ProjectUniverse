extends Control

var control_prefab = preload("res://UI/control_setting.tscn")

@onready var is_assigning = false
var queued_graphics_changes = { }

@onready var graphics_button_list = {
	"windowMode": find_child("AssignFullscreen") as BaseButton
}

@onready var controls_button_list = { }
@onready var readable_control_names = {
	"move_hover": "Move",
	"end_turn": "End Turn",
	"use_ability_1": "Ability 1",
	"use_ability_2": "Ability 2",
	"use_ability_3": "Ability 3",
	"use_ability_4": "Ability 4"
}

# Globals for keybinding
var cur_action: String
var cur_bind_index: int


func _ready():
	visibility_changed.connect(_visibility_changed)
	
	# graphics inputs will have varied logics, so they cannot be iterated
	graphics_button_list["windowMode"].add_item("Windowed", DisplayServer.WINDOW_MODE_MAXIMIZED)
	graphics_button_list["windowMode"].add_item("Borderless", DisplayServer.WINDOW_MODE_FULLSCREEN)
	graphics_button_list["windowMode"].add_item("Fullscreen", DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	graphics_button_list["windowMode"].selected = Game.settings.graphics["windowMode"]
	
	for control in Game.settings.controls:
		var ui = control_prefab.instantiate()
		
		# If this control is mapped as a readable name, use that
		if control in readable_control_names:
			ui.find_child("Label").set_text(readable_control_names[control])
		else:
			ui.find_child("Label").set_text(control)
		
		var primary = ui.find_child("Primary") as Button
		primary.pressed.connect(_start_assign_key.bind(control, 0))
		if InputMap.action_get_events(control).size() >= 1:
			primary.set_text(OS.get_keycode_string(InputMap.action_get_events(control)[0].physical_keycode))
		controls_button_list["%s_primary" % control] = primary
		
		var secondary = ui.find_child("Secondary") as Button
		secondary.pressed.connect(_start_assign_key.bind(control, 1))
		if InputMap.action_get_events(control).size() >= 2:
			secondary.set_text(OS.get_keycode_string(InputMap.action_get_events(control)[1].physical_keycode))
		controls_button_list["%s_secondary" % control] = secondary
		
		%ControlsBox.add_child(ui)
		pass
	
	#for button in controls_button_list:
		#var index = button[-1] as int
		#var events = InputMap.action_get_events(button.substr(0, button.length() - 1))
		#if events.size() <= index:
			#push_warning("Button ", button, " does not exist for InputMap")
			#continue
		## Sets the default text of each button to be whatever is initially stored as the keybindings
		## Note: tried using .keycode, returns 0 when not set by game settings file. .physical_keycode works, though. Bug?
		#controls_button_list[button].set_text(OS.get_keycode_string(InputMap.action_get_events(button.substr(0, button.length() - 1))[button[-1] as int].physical_keycode))


# Reset UI features for non-applied changes
func _visibility_changed():
	print(Game.settings.graphics["windowMode"])
	graphics_button_list["windowMode"].selected = Game.settings.graphics["windowMode"]


func _toggle_graphics_setting(val: Variant, tag: String):
	queued_graphics_changes[tag] = val
	#Game.settings.toggle_graphics_setting(tag, val)


func _start_assign_key(key: String, bind_index: int):
	cur_action = key
	cur_bind_index = bind_index
	is_assigning = true


func _apply_settings():
	for setting in queued_graphics_changes:
		Game.settings.toggle_graphics_setting(setting, queued_graphics_changes[setting])
	
	Game.settings.apply_graphics_from_saved()


# Key reassignment
func _input(event):
	if !is_assigning:
		return
		
	# While assigning a key, consume every input coming in,
	# so they aren't caught by something else
	get_viewport().set_input_as_handled()
	
	if event is InputEventKey:
		var event_list = Game.settings.controls[cur_action]
		var event_is_duplicate = event_list.any(func(e): return e != null && e.keycode == event.keycode)
		print(event_is_duplicate)
		
		# If the action doesn't have this index yet,
		# then there is no existing control to rebind
		if null in event_list:
			if !event_is_duplicate:
				Game.settings.rebind_control(cur_action, null, event)
		else:
			# If the event is already assigned to this action,
			# then just remove the event currently in place
			if event_is_duplicate && event_list[cur_bind_index].keycode != event.keycode:
				Game.settings.rebind_control(cur_action, event_list[cur_bind_index], null)
				controls_button_list[cur_action + ("_primary" if cur_bind_index == 0 else "_secondary")].set_text("")
			else:
				Game.settings.rebind_control(cur_action, event_list[cur_bind_index], event)
		
		# Update the button text
		if !event_is_duplicate:
			controls_button_list[cur_action + ("_primary" if cur_bind_index == 0 else "_secondary")].set_text(OS.get_keycode_string(event.keycode))
		is_assigning = false
