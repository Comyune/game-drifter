extends StaticBody2D
const CollisionResult = preload("res://types/collision_result.gd")

export (String) var character = 'A'

onready var label = $Label

func _ready():
	label.text = character

func on_collide_with_player(player):
	var result = CollisionResult.new()
	result.addition = character
	queue_free()
	return result
