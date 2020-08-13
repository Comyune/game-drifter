extends Node
const TailState = preload("res://player/tail_state")
const ChainLink = preload("res://player/chain_link/chain_link.tscn")

onready var ship       = $Ship
onready var start_link = $StartLink
onready var tail_state = TailState.new()

func _ready:
	connect("player_collision", self, "handle_collision_result")

func handle_collision_result(collision_result):
	tail_state.update_with_collision_result(collision_result)
	remove_redundant_links()
	ensure_chain_links()

# Tail handling

func remove_redundant_chain_links():
	if chain_links.size() <= tail_state.size(): return

	for i in range(chain_links.size() - tail_state.size()):
		chain_links[-1].queue_free()

func ensure_chain_links() -> void:
    for i in range(tail_state.size()):
		if chain_links.size() < i + 1: create_chain_link(i)

func create_chain_link(index):
	var new_link = ChainLink.instance()
	new_link.character = tail_state.character_at(index)
	add_child(new_link)
