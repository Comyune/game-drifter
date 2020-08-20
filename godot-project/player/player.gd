extends Node
const TailState  = preload("res://player/tail_state.gd")
const ChainLink  = preload("res://player/chain_link/chain_link.tscn")
const ChainJoint = preload("res://player/chain_joint/chain_joint.tscn")
const Missile    = preload("res://player/projectiles/missile.tscn")

onready var ship           = $Ship
onready var control_state  = $Ship/ControlState
onready var shooting_timer = $ShootingTimer
onready var tail_state     = TailState.new()

const link_offset = Vector2(0, 55)
var chain_links = []
var chain_joints = []

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

	for i in range(chain_links.size() - tail_state.size()):
		remove_link_at(chain_links.size() - i - 1)

func remove_link_at(index):
	var joint = chain_joints[index]
	var link = chain_links[index]
	chain_joints.erase(joint)
	chain_links.erase(link)
	joint.queue_free()
	link.queue_free()

func ensure_chain_links() -> void:
	if(tail_state.size() == 0): return

	for i in range(tail_state.size()):
		if chain_links.size() < i + 1:
			create_chain_link(i)
		else:
			chain_links[i].init(tail_state.character_at(i))

func create_chain_link(index):
	var target_link = last_link()
	var new_position = target_link.position + link_offset.rotated(target_link.rotation)
	# Create the link, add its letter, and attach to scene
	var new_link = ChainLink.instance()
	new_link.init(tail_state.character_at(index))
	new_link.position = new_position
	add_child(new_link)
	# Position the new link relative to the last link in the chain
	# Create a joint to pin the 2 links together
	var joint = ChainJoint.instance()
	joint.node_a = new_link.get_path()
	joint.node_b = target_link.get_path()
	joint.position = new_position
	add_child(joint)
	# Add the new link and joint to our arrays
	chain_links.push_back(new_link)
	chain_joints.push_back(joint)

func last_link():
	if chain_links.size() < 1: return ship
	return chain_links[-1]

func can_shoot() -> bool:
	if shooting_timer.time_left != 0: return false
	if tail_state.size() < 1: return false
	return true

# Signal Handlers

func on_ship_collision(collision_result):
	tail_state.update_with_collision_result(collision_result)
	update_tail()

func on_ship_shoot():
	if !can_shoot(): return
	shooting_timer.start()

	var letter = tail_state.pop()
	var missile = Missile.instance()
	missile.init(letter, ship)
	add_child(missile)
	update_tail()

func on_ship_invert():
	tail_state.invert()
	update_tail()
