extends Node

static var player: PlayerManager
static var enemy_list: Array

static var turn_order: Array
static var current_turn: int

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $PlayerActors as PlayerManager
	enemy_list = ["Some Guy"]
	
	# TODO: logic for deciding turn order
	turn_order = [player]
	turn_order.append_array(enemy_list)

# Temp way to increment the turn
func _process(delta):
	if Input.is_action_just_pressed("end_turn"):
		start_next_turn()

func start_next_turn():
	# End the current turn
	if turn_order[current_turn] is PlayerManager:
		turn_order[current_turn].change_turn(false)
	else:
		# toggle enemy turn off
		pass
	
	# Increment the turn
	current_turn += 1
	if current_turn >= turn_order.size():
		current_turn = 0
	
	# Start the next turn
	print("Turn {} ended. Starting turn {}.".format([current_turn - 1, current_turn], "{}"))
	if turn_order[current_turn] is PlayerManager:
		turn_order[current_turn].change_turn(true)
	else:
		# toggle enemy turn on
		pass
