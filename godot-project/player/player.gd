extends Node
const TailState  = preload("res://player/tail_state.gd")
const ChainLink  = preload("res://player/chain_link/chain_link.tscn")
const ChainJoint = preload("res://player/chain_joint.tscn")

const link_offset = Vector2(0, 80)

onready var ship       = $Ship
onready var start_link = $StartLink
onready var tail_state = TailState.new()

var chain_links = []

func _ready():
	var _connection = ship.connect(
		"collision", self, "on_ship_collision"
	)

func on_ship_collision(collision_result):
	tail_state.update_with_collision_result(collision_result)
	remove_redundant_chain_links()
	ensure_chain_links()

# Tail handling

func remove_redundant_chain_links():
	if chain_links.size() <= tail_state.size(): return

	for _i in range(chain_links.size() - tail_state.size()):
		chain_links[-1].queue_free()

func ensure_chain_links() -> void:
	for i in range(tail_state.size()):
		if chain_links.size() < i + 1: create_chain_link(i)

func create_chain_link(index):
	var target_link = last_link()
	# Create the link, add its letter, and attach to scene
	var new_link = ChainLink.instance()
	new_link.character = tail_state.character_at(index)
	new_link.position = link_offset
	target_link.add_child(new_link)
	print("New link position: 0, 0", new_link.position)
	print("Target link position: 0, 80", target_link.position)
	# Position the new link relative to the last link in the chain
	# Create a joint to pin the 2 links together
	var joint = ChainJoint.instance()
	joint.node_a = new_link.get_path()
	joint.node_b = target_link.get_path()
	joint.position = link_offset
	target_link.add_child(joint)
	# Add the new link to our chain_links array
	chain_links.push_back(new_link)

func last_link():
	if chain_links.size() < 1: return start_link
	return chain_links[-1]
