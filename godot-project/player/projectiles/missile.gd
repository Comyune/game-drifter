extends RigidBody2D

export (float) var initial_impulse  = 200.0
export (float) var acceleration     = 10.0
export (float) var maximum_velocity = 300.0
var force = Vector2(0, -acceleration)

func _enter_tree():
	apply_impulse(
		Vector2.ZERO,
		Vector2(0, -initial_impulse).rotated(rotation)
	)

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if state.get_linear_velocity().length() > maximum_velocity: return
	add_central_force(force.rotated(rotation))
