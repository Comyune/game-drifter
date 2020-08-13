extends StaticBody2D
const CollisionResult = preload("res://types/collision_result.gd")

export (String) var character = 'A'

onready var label = $Label

func _ready():
	label.text = character

func on_collide_with_ship(_ship):
	var result = CollisionResult.new()
	result.addition = character
	die()

func die():
	queue_free()
	return result
