extends Scenario

static var enemy_list: Array

static var turn_order: Array
static var current_turn: int

func _ready():
	find_child("TextureButton").pressed.connect(self.start_next_turn)
	register_character(Scenario.ENEMY, find_child("Evil_guy"))
	
	var preview_button = find_child("Preview") as TextureButton
	preview_button.button_pressed
	
func handle_input(camera, event, position, normal, shape_idx):
	pass
