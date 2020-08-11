# Collision result encodes the effect a collision should have on a player
extends Reference

var addition : String = '' setget set_addition, get_addition
func get_addition(): return addition
func set_addition(value): addition = value

var subtraction : int = 0 setget set_subtraction, get_subtraction
func set_subtraction(value): subtraction = value
func get_subtraction(): return subtraction
