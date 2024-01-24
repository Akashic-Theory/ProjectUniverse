extends Container

var character: Character
var buttons: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons = $HBoxContainer.get_children()

func select(_character):
	if character == _character:
		set_visible(true)


func deselect(_character):
	if character == _character:
		set_visible(false)
