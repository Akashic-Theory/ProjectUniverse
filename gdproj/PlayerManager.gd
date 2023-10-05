class_name PlayerManager
extends Node

static var players: Array
static var selected_player: int

# Called when the node enters the scene tree for the first time.
func _ready():
	players = find_children("", "PlayerInput")
	for i in range(players.size()):
		players[i].id = i
		players[i].selected.connect(on_change_selected.bind())
	
	selected_player = -1

# Called when the player changes their currently selected character
func on_change_selected(id, status):
	if status == false:
		selected_player = -1
		return
	
	selected_player = id

func change_turn(state: bool):
	for p in players:
		p.change_turn(state)
