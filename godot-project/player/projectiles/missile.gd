extends RigidBody2D

const ENEMIES_GROUP := "enemies"

export (float) var initial_impulse  = 600.0
export (float) var maximum_velocity = 400.0
export (float) var acceleration     = 10.0

onready var collision_effect := $CollisionEffect
onready var death_timer      := $DeathTimer
onready var sprite           := $Sprite

var force := Vector2(0, -acceleration)

func _ready():
	var _connection = connect("body_entered", self, "die")
	_connection = death_timer.connect("timeout", self, "queue_free")
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

func die(body):
	if body.get_groups().has(ENEMIES_GROUP): body.die()

	sprite.visible = false
	collision_effect.emitting = true
	sleeping = true
	death_timer.start()
