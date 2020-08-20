# This wraps the contents of a player's tail
extends Reference

export var contents : String = '' setget set_contents, get_contents
func set_contents(value : String): contents = value
func get_contents(): return contents

func size() -> int: return contents.length()
func letters() -> PoolStringArray: return contents.split("", true)
func character_at(index): return contents[index]

func invert() -> void:
	print("TODO: Invert not working")

func update_with_collision_result(collision_result) -> void:
	contents.erase(0, collision_result.subtraction)
	contents = contents + collision_result.addition

func pop() -> String:
	# TODO: Remove letter as well
	return contents.substr(0, 1)
