extends Scenario

static var enemy_list: Array

static var turn_order: Array
static var current_turn: int

# Temp reference to region for testing
@onready var region = find_child("Region")
func _ready():
	# Connect combat UI buttons
	find_child("EndTurnButton").pressed.connect(self.start_next_turn)
	
	var terrain = find_child("TerrainCollider")
	terrain.input_event.connect(self.handle_input.bind(terrain))
	
	var party = get_tree().get_nodes_in_group("party")
	for character in party:
		register_character(Scenario.PLAYER, character)
	
	register_character(Scenario.ENEMY, find_child("Evil_guy"))
	
	set_turn(Scenario.PLAYER)
	print_characters()
	
	#var preview_button = find_child("Preview") as TextureButton
	#preview_button.button_pressed

