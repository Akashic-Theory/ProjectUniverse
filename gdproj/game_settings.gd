extends Resource
class_name GameSettings

## Saved graphics settings
@export var graphics: Dictionary
## Constant default control scheme
var default_controls: Dictionary
## Saved control scheme
@export var controls: Dictionary

signal request_viewport_change(change_tag: String, value: Variant)

# Note for resources: values set in _init() are overridden
# when the resource finishes loading from file
func _init():
	graphics = {
		"windowMode":  ProjectSettings.get_setting("display/window/size/mode")
	}
	
	# Manually assigning modifiable controls
	default_controls = {
		"move_hover": InputMap.action_get_events("move_hover"),
		"end_turn": InputMap.action_get_events("end_turn"),
		"use_ability_1": InputMap.action_get_events("use_ability_1"),
		"use_ability_2": InputMap.action_get_events("use_ability_2"),
		"use_ability_3": InputMap.action_get_events("use_ability_3"),
		"use_ability_4": InputMap.action_get_events("use_ability_4")
	}
	
	controls = default_controls


## Apply the graphics settings that have been saved
func apply_graphics_from_saved():
	print("applying settings...")
	for tag in graphics:
		request_viewport_change.emit(tag, graphics[tag])
		prints(tag, graphics[tag])


#TODO: Implement timed preview on graphics changes
func toggle_graphics_setting(tag: String, val: Variant):
	graphics[tag] = val


## Clear default bindings and apply saved ones
func bind_controls_from_saved():
	for action in controls:
		InputMap.action_erase_events(action)
		for event in controls[action]:
			if event != null:
				InputMap.action_add_event(action, event)


## Rebind a single control
# Supports null values. If old is null, acts as a bind. if new is null, acts as an unbind
func rebind_control(action: String, old: InputEvent, new: InputEvent):
	var index = controls[action].find(old)
	controls[action][index] = new
	
	#InputMap.action_erase_event(action, old)
	#InputMap.action_add_event(action, new)
	#controls[action] = InputMap.action_get_events(action)

#
### Bind a single control
#func bind_control(action: String, new: InputEvent):
	#if null in controls[action]:
		#
	#
	#InputMap.action_add_event(action, new)
	#controls[action] = InputMap.action_get_events(action)
#
#
### Unbind a single control
#func unbind_control(action: String, new: InputEvent):
	#InputMap.action_erase_event(action, new)
	#controls[action] = InputMap.action_get_events(action)
