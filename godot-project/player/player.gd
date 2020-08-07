extends KinematicBody2D
var ControlState = load('res://player/control_state.gd')
var TailState = load('res://types/tail_state.gd')

export (int) var speed = 5
export (float) var rotation_speed = 0.075
export (float) var rotation_friction = 0.99
export (float) var velocity_friction = 0.99

const gravity = 98.0
const left = Vector2(-1, 0)
const right = Vector2(1, 0)

var velocity = Vector2()
var rotation_velocity = 0
var tail_state = TailState.new()
var control_state

onready var tail_component = $Tail
onready var particles = $Particles

func _ready(): control_state = ControlState.new()

func _physics_process(delta):
	process_rotation(delta)
	process_velocity(delta)
	handle_movement_and_collisions(delta)
	handle_particles()

func handle_movement_and_collisions(delta):
	var collision = move_and_collide(velocity * delta)
	if collision: handle_collision(collision)

func handle_particles():
	particles.emitting = control_state.is_thrusting()
	if control_state.is_thrusting():
		particles.direction = Vector2(control_state.thrust_direction(), 0)

func process_rotation(delta):
	rotation_velocity *= rotation_friction # Apply friction to rotation
	rotation_velocity += control_state.rotation_direction()
	rotation += rotation_velocity * rotation_speed * delta

func process_velocity(delta):
	velocity *= velocity_friction # Apply friction to velocity

	# Get thrust direction, rotate to where the player is looking and apply as velocity
	var thrust_amount = control_state.thrust_direction() * speed
	velocity += Vector2(-thrust_amount, 0).rotated(rotation)
	velocity += Vector2(0, gravity * delta) # Apply gravity

func handle_collision(collision):
	var collider = collision.collider

	# If the colliding object doesn't have a custom collision handler, just bounce.
	if !collider.has_method("on_collide_with_player"):
		velocity = velocity.bounce(collision.normal)
		return

	var collision_result = collider.on_collide_with_player(self)
	if collision_result:
		tail_state.update_with_collision_result(collision_result)
		$Tail.text = tail_state.contents

func shoot():
	pass
