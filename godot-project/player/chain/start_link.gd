extends Node2D
var TailState = preload('res://types/tail_state.gd')
var Link = preload('res://player/chain/chain_link.tscn')
onready var SceneMode = $"root/SceneMode"
var links = []

func _ready():
	if SceneMode.on(): position = Vector2(200, 200)

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
	add_child(new_link)
	new_link.character = character
	var target = next_link_target()
	new_link.attach_to(target)
	var link_position = target.find_node('LinkPosition')
	new_link.position = new_link.to_local(link_position.global_position)

func next_link_target():
	if(links.empty()): return self
	return links[-1]
