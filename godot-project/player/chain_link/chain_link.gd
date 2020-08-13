extends RigidBody2D

export (String) var character = ''
onready var label = $Label

func _ready(): label.text = character
