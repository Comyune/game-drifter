# This wraps the contents of a player's tail
extends Reference

export var contents : String = '' setget set_contents, get_contents
func set_contents(value): contents = value
func get_contents(): return contents

func size() -> int: return contents.length()
func letters() -> PoolStringArray: return contents.split("", true)

func invert() -> void:
	var letters = contents.split("")
	letters.invert()
	contents = letters.join("")

func update_with_collision_result(collision_result) -> void:
	contents.erase(0, collision_result.subtraction)
	contents = contents + collision_result.addition
