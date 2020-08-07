extends Node2D
var TailState = load('res://types/tail_state.gd')
var Link = load('res://player/chain/chain_link.tscn')

var links = []

func _ready():
	pass

func set_tail_state(tail_state) -> void:
	if links.size() > tail_state.size():
		remove_redundant_links()

	var letters = tail_state.letters()
	for i in range(letters.size()):
		ensure_chain_link(letters, i)

func remove_redundant_links(): pass

func ensure_chain_link(letters : PoolStringArray, i : int) -> void:
	if links.size() < i + 1: create_link(letters[i])

func create_link(character):
	var new_link = Link.instance()
	new_link.character = character
	add_child(new_link)
	var target = next_link_target()
	new_link.attach_to(target)
	var link_position = target.find_node('LinkPosition')
	# new_link.position = new_link.to_local(link_position.to_global)
	new_link.position = target.position

func next_link_target():
	if(links.empty()): return self
	return links[-1]
