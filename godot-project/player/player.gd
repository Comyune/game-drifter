extends Node
const TailState  = preload("res://player/tail_state.gd")
const ChainLink  = preload("res://player/chain_link/chain_link.tscn")
const ChainJoint = preload("res://player/chain_joint/chain_joint.tscn")
const Missile    = preload("res://player/projectiles/missile.tscn")

const link_offset = Vector2(0, 55)

onready var ship          = $Ship
onready var control_state = $Ship/ControlState
onready var tail_state    = TailState.new()

var chain_links = []

func _ready():
	var _connection = ship.connect(
		"collision", self, "on_ship_collision"
	)
	_connection = control_state.connect(
		"shoot", self, "on_ship_shoot"
	)
	_connection = control_state.connect(
		"invert", self, "on_ship_invert"
	)

# Tail handling

func update_tail():
	remove_redundant_chain_links()
	ensure_chain_links()

func remove_redundant_chain_links():
	if chain_links.size() <= tail_state.size(): return

	for _i in range(chain_links.size() - tail_state.size()):
		chain_links[-1].queue_free()

func ensure_chain_links() -> void:
	for i in range(tail_state.size()):
		if chain_links.size() < i + 1: create_chain_link(i)

func create_chain_link(index):
	var target_link = last_link()
	var new_position = target_link.position + link_offset.rotated(target_link.rotation)
	# Create the link, add its letter, and attach to scene
	var new_link = ChainLink.instance()
	new_link.character = tail_state.character_at(index)
	new_link.position = new_position
	add_child(new_link)
	# Position the new link relative to the last link in the chain
	# Create a joint to pin the 2 links together
	var joint = ChainJoint.instance()
	joint.node_a = new_link.get_path()
	joint.node_b = target_link.get_path()
	joint.position = new_position
	add_child(joint)
	# Add the new link to our chain_links array
	chain_links.push_back(new_link)

func last_link():
	if chain_links.size() < 1: return ship
	return chain_links[-1]

# Signal Handlers

func on_ship_collision(collision_result):
	tail_state.update_with_collision_result(collision_result)
	update_tail()

func on_ship_shoot():
	var missile = Missile.instance()
	missile.position = ship.position
	missile.rotation = ship.rotation
	add_child(missile)

func on_ship_invert():
	print("Tail state before:", tail_state.contents)
	tail_state.invert()
	print("Tail state after:", tail_state.contents)
	update_tail()
