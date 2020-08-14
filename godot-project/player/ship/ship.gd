extends KinematicBody2D
var ControlState = preload('res://player/ship/control_state.gd')

signal collision(result)

export (int)   var speed             = 15
export (float) var rotation_speed    = 0.1
export (float) var rotation_friction = 0.97
export (float) var velocity_friction = 0.98

const gravity      : float   = 98.0
const left         : Vector2 = Vector2(-1, 0)
const right        : Vector2 = Vector2(1, 0)

var velocity          : Vector2 = Vector2()
var rotation_velocity : float   = 0.0

onready var control_state  : Node           = $ControlState
onready var tail_component : Label          = $Tail
onready var particles      : CPUParticles2D = $Particles

# Frame processing

func _process(delta):
	# Get the steering of the player and apply to rotation velocity
	rotation_velocity += control_state.rotation_direction()
	# Get thrust direction, rotate to where the player is looking and apply as velocity
	var thrust_amount = control_state.thrust_direction() * speed
	velocity += Vector2(0, thrust_amount).rotated(rotation)
	velocity += Vector2(0, gravity * delta) # Apply gravity
	handle_particles()

func handle_particles():
	particles.emitting = control_state.is_thrusting()
	if control_state.is_thrusting():
		particles.direction = Vector2(0, -control_state.thrust_direction())

# Physics processing

func _physics_process(delta):
	process_rotation(delta)
	process_velocity(delta)
	handle_movement_and_collisions(delta)

func process_rotation(delta):
	rotation_velocity *= rotation_friction # Apply friction to rotation
	rotation += rotation_velocity * rotation_speed * delta

func process_velocity(_delta):
	velocity *= velocity_friction # Apply friction to velocity

func handle_movement_and_collisions(delta):
	var collision = move_and_collide(velocity * delta)
	if collision: handle_collision(collision)

func handle_collision(collision):
	var collider = collision.get_collider()

	# If the colliding object doesn't have a custom collision handler, just bounce.
	if !collider.has_method("on_collide_with_ship"):
		velocity = velocity.bounce(collision.normal)
		return

	var collision_result = collider.on_collide_with_ship(self)
	if collision_result: emit_signal('collision', collision_result)
