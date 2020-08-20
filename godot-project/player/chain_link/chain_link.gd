extends RigidBody2D

const ChainJoint = preload("res://player/chain_joint/chain_joint.tscn")
export (String) var character = ''

const link_offset = Vector2(0, 55)
var joint : Joint2D

func init(letter): $Label.text = letter
