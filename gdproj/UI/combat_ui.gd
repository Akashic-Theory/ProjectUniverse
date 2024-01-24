extends CanvasLayer

var action_button_template = preload("res://UI/player_action_buttons.tscn")
var character_status_template = preload("res://UI/character_ui.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

## Load a character into the UI
func register_character(character: Character):
	## Add the Character profile
	var character_status : Control = character_status_template.instantiate()
	
	# TODO: Load Character stats and sprite
	
	%CharacterContainer/VBoxContainer.add_child(character_status)
	
	## Add the Action buttons
	var action_buttons : Control = action_button_template.instantiate()
	action_buttons.set_visible(false)
	
	# Connect variables and functions
	action_buttons.character = character
	($"/root/Scenario").character_selected.connect(action_buttons.select)
	($"/root/Scenario").character_deselected.connect(action_buttons.deselect)
	
	# TODO: Load ability sprites
	
	%ActionContainer.add_child(action_buttons)
