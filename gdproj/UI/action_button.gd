extends TextureButton
## Hooks button into actions and self-disables depending on game state

## The StringName of the action this button should bind to
@export var actionName : StringName

# Called when the node enters the scene tree for the first time.
func _ready():
	# Validity check for action
	if !InputMap.get_actions().has(actionName):
		push_error("Provided action \"", actionName, "\" is not a valid action")
		set_disabled(true)
		return
	
	($"/root/Scenario").turn_started.connect(_on_turn.bind(true))
	($"/root/Scenario").turn_ended.connect(_on_turn.bind(false))


func _pressed():
	# Use only if this is not a toggle button
	if toggle_mode:
		return
	
	Input.action_press(actionName)
	await button_up
	Input.action_release(actionName)


# Won't be used if not a toggle button
func _toggled(toggled_on):
	if toggled_on:
		Input.action_press(actionName)
	else:
		Input.action_release(actionName)


## If the turn is/was the player's, set disabled on/off
func _on_turn(team, is_turn_start):
	if team == Scenario.TeamType.PLAYER:
		set_disabled(!is_turn_start)
