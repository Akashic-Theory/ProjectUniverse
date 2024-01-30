extends Container

var character: Character
var buttons: Array

@export var sprite_sets: Array[SpriteSet]

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons = $HBoxContainer.get_children()
	sprite_sets[0].apply_to(buttons[0])
	
	# Connect signal to allow movement label to update
	character.moved.connect($HBoxContainer/MoveButton/RemainingMoveLabel.update_label)
	$HBoxContainer/MoveButton/RemainingMoveLabel.update_label(character.get_remaining_movement())

func select(_character):
	if character == _character:
		set_visible(true)


func deselect(_character):
	if character == _character:
		set_visible(false)
