extends Control

@onready var is_assigning = false

# Silly little hard-coded list :)
@onready var button_list = {
	"move_hover0": find_child("AssignMove0") as Button,
	"move_hover1": find_child("AssignMove1") as Button,
	"end_turn0": find_child("AssignEndTurn0") as Button,
	"end_turn1": find_child("AssignEndTurn1") as Button,
	"use_ability_10": find_child("AssignAbilityOne0") as Button,
	"use_ability_11": find_child("AssignAbilityOne1") as Button,
	"use_ability_20": find_child("AssignAbilityTwo0") as Button,
	"use_ability_21": find_child("AssignAbilityTwo1") as Button,
	"use_ability_30": find_child("AssignAbilityThree0") as Button,
	"use_ability_31": find_child("AssignAbilityThree1") as Button,
	"use_ability_40": find_child("AssignAbilityFour0") as Button,
	"use_ability_41": find_child("AssignAbilityFour1") as Button
}

# Globals for keybinding
var cur_action: String
var cur_bind_index: int

func _ready():
	for button in button_list:
		var index = button[-1] as int
		var events = InputMap.action_get_events(button.substr(0, button.length() - 1))
		if events.size() <= index:
			push_warning("Button ", button, " does not exist for InputMap")
			continue
		# Sets the default text of each button to be whatever is initially stored as the keybindings
		# Note: tried using .keycode, returns 0 when not set by game settings file. .physical_keycode works, though. Bug?
		button_list[button].set_text(OS.get_keycode_string(InputMap.action_get_events(button.substr(0, button.length() - 1))[button[-1] as int].physical_keycode))

func _start_assign_key(key: String, bind_index: int):
	cur_action = key
	cur_bind_index = bind_index
	is_assigning = true

# Key reassignment
func _input(event):
	if !is_assigning:
		return
		
	# While assigning a key, consume every input coming in,
	# so they aren't caught by something else
	get_viewport().set_input_as_handled()
	
	if event is InputEventKey:
		var event_list = InputMap.action_get_events(cur_action)
		var event_is_duplicate = event_list.any(func(e): return e.keycode == event.keycode)
		
		# If the action doesn't have this index yet,
		# then there is no existing control to rebind
		if event_list.size() <= cur_bind_index:
			if !event_is_duplicate:
				Game.settings.bind_control(cur_action, event)
		else:
			# If the event is already assigned to this action,
			# then just remove the event currently in place
			if event_is_duplicate && event_list[cur_bind_index].keycode != event.keycode:
				Game.settings.unbind_control(cur_action, event_list[cur_bind_index])
				button_list[cur_action + str(cur_bind_index)].set_text("")
			else:
				Game.settings.rebind_control(cur_action, event_list[cur_bind_index], event)
		
		# Update the button text
		if !event_is_duplicate:
			button_list[cur_action + str(cur_bind_index)].set_text(OS.get_keycode_string(event.keycode))
		is_assigning = false
