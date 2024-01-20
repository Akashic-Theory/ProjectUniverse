extends Resource
class_name GameSettings

## Saved control scheme
@export var controls: Dictionary

# Note for resources: values set in _init() are overridden
# when the resource finishes loading from file
func _init():
	# Manually assigning modifiable controls
	controls = {
		"move_hover": InputMap.action_get_events("move_hover"),
		"end_turn": InputMap.action_get_events("end_turn"),
		"use_ability_1": InputMap.action_get_events("use_ability_1"),
		"use_ability_2": InputMap.action_get_events("use_ability_2"),
		"use_ability_3": InputMap.action_get_events("use_ability_3"),
		"use_ability_4": InputMap.action_get_events("use_ability_4")
	}

## Clear default bindings and apply saved ones
func bind_controls_from_file():
	for action in controls:
		InputMap.action_erase_events(action)
		for event in controls[action]:
			InputMap.action_add_event(action, event)

## Rebind a single control
func rebind_control(action: String, old: InputEvent, new: InputEvent):
	InputMap.action_erase_event(action, old)
	InputMap.action_add_event(action, new)
	controls[action] = InputMap.action_get_events(action)


## Bind a single control
func bind_control(action: String, new: InputEvent):
	InputMap.action_add_event(action, new)
	controls[action] = InputMap.action_get_events(action)


## Unbind a single control
func unbind_control(action: String, new: InputEvent):
	InputMap.action_erase_event(action, new)
	controls[action] = InputMap.action_get_events(action)
