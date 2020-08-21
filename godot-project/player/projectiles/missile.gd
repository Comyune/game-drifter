extends RigidBody2D

const ENEMIES_GROUP := "enemies"

export (float) var initial_impulse  = 2000.0
export (float) var acceleration     = 50.0
export (float) var homing_strength  = 100.0
export (float) var target_acquired_slow_down = 15.0

onready var collision_effect := $CollisionEffect
onready var death_timer      := $DeathTimer
onready var sprite           := $Sprite
onready var sensor           := $Sensor

var force  := Vector2(0, -acceleration)
var target = null

func _ready():
	var _connection = connect("body_entered", self, "die")
	_connection = death_timer.connect("timeout", self, "queue_free")
	_connection = sensor.connect("body_entered", self, "on_sensor_body_entered")

	var shooting_impulse = Vector2(0, -initial_impulse).rotated(rotation)
	apply_impulse(Vector2.ZERO, shooting_impulse)

func init(letter: String, shooter: PhysicsBody2D):
	$Label.text = letter
	position = shooter.position
	rotation = shooter.rotation
	apply_impulse(Vector2.ZERO, shooter.velocity)

func _integrate_forces(state) -> void:
	if !target:
		add_central_force(2 * force.rotated(rotation))
		return
	else:
		add_central_force(force.rotated(rotation))

	var desired_change_in_position = position - target.position

	var desired_direction = (
		state.linear_velocity - desired_change_in_position
	).angle() + PI/2

	var impulse = lerp_angle(rotation, desired_direction, 1.0)
	apply_torque_impulse((rotation - impulse) * -homing_strength)


func die(body):
	if !sleeping && body.get_groups().has(ENEMIES_GROUP):
		body.die()

	sprite.visible = false
	collision_effect.emitting = true
	sleeping = true
	death_timer.start()

func on_sensor_body_entered(body):
	if target: return
	target = body
	apply_central_impulse(Vector2(0, target_acquired_slow_down))
