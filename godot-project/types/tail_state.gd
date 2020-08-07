# This wraps the contents of a player's tail
extends Reference

var contents : String = ''

func size() -> int: return contents.length()
func letters() -> PoolStringArray: return contents.split("", true)

func invert() -> void:
	print("invert_tail before:", contents)
	var letters = contents.split("")
	letters.invert()
	contents = letters.join("")
	print("invert_tail after:", contents)

func update_with_collision_result(collision_result) -> void:
	contents.erase(0, collision_result.subtraction)
	contents = contents + collision_result.addition
