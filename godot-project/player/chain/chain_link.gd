extends RigidBody2D

export (String) var character = ''
onready var label = $Label
onready var joint = $PinJoint2D

func _ready(): label.text = character

func attach_to(node : Node2D):
	joint.node_b = node.find_node('LinkPosition').get_path()
