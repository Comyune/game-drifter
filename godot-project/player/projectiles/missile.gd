extends RigidBody2D

export (float)  var initial_impulse  = 400.0
export (float)  var acceleration     = 10.0
export (float)  var maximum_velocity = 300.0

var force = Vector2(0, -acceleration)

func _ready():
	var _connection = connect("body_entered", self, "_on_body_entered")
	var shooting_impulse = Vector2(0, -initial_impulse).rotated(rotation)
	apply_impulse(Vector2.ZERO, shooting_impulse)

func init(letter: String, shooter: PhysicsBody2D):
	$Label.text = letter
	position = shooter.position
	rotation = shooter.rotation
	apply_impulse(Vector2.ZERO, shooter.velocity)

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if state.get_linear_velocity().length() > maximum_velocity: return
	add_central_force(force.rotated(rotation))

func _on_body_entered(_body): die()
func die(): queue_free()
