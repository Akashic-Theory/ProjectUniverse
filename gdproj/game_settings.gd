extends Resource
class_name GameSettings

@export var graphics: Dictionary
## Saved control scheme
@export var controls: Dictionary

signal request_viewport_change(change_tag: String, value: Variant)

# Note for resources: values set in _init() are overridden
# when the resource finishes loading from file
func _init():
	graphics = {
		"fullscreen":  true if ProjectSettings.get_setting("display/window/size/mode") == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else false
	}
	
	# Manually assigning modifiable controls
	controls = {
		"move_hover": InputMap.action_get_events("move_hover"),
		"end_turn": InputMap.action_get_events("end_turn"),
		"use_ability_1": InputMap.action_get_events("use_ability_1"),
		"use_ability_2": InputMap.action_get_events("use_ability_2"),
		"use_ability_3": InputMap.action_get_events("use_ability_3"),
		"use_ability_4": InputMap.action_get_events("use_ability_4")
	}

## Apply the graphics settings that have been saved
func apply_graphics_from_file():
	print("applying settings...")
	for tag in graphics:
		apply_graphics_setting(tag)
		prints(tag, graphics[tag])

## Applies the given graphics setting from the saved value
func apply_graphics_setting(tag: String):
	# Because each setting needs to be treated differently, we need a match tree to set every setting
	request_viewport_change.emit(tag, graphics[tag])


#TODO: Implement timed preview on graphics changes
#TODO: Add an apply button instead of toggling instantly
func toggle_graphics_setting(tag: String, val: bool):
	graphics[tag] = val
	apply_graphics_setting(tag)


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
