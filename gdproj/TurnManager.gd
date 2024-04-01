extends Scenario

static var enemy_list: Array

static var turn_order: Array
static var current_turn: int

# Temp reference to region for testing
@onready var region = find_child("Region")

func _ready():
	# Connect combat UI buttons
	find_child("EndTurnButton").pressed.connect(self.start_next_turn)
	
	var terrain = %TerrainCollider
	terrain.input_event.connect(_handle_input.bind(terrain))
	
	var party = get_tree().get_nodes_in_group("party")
	for character in party:
		register_character(PLAYER, character)
		%CombatUI.register_character(character)
	
	register_character(ENEMY, find_child("Evil_guy"))
	
	set_turn(PLAYER)
	print_characters()
	
	#var preview_button = find_child("Preview") as TextureButton
	#preview_button.button_pressed

func _handle_input(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int, source: Object):
	handle_input(camera, event, position, normal, shape_idx, source)
	var terrain = source as Area3D
	
	if terrain == %TerrainCollider:
		
		var cur_selected = get_selected()
		# TODO: Add additional check for whether it is the player's turn
		if cur_selected && !cur_selected.is_moving():
			if Input.is_action_pressed("move_hover"):
				cur_selected.draw_move_path()
				if event.is_action_pressed("start_move"):
					cur_selected.start_movement()
			cur_selected.set_target(position)
