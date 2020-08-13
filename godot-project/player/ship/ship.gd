extends KinematicBody2D
var ControlState = preload('res://player/control_state.gd')

signal player_collision(result)

export (int)   var speed             = 5
export (float) var rotation_speed    = 0.075
export (float) var rotation_friction = 0.98
export (float) var velocity_friction = 0.99

const gravity      : float   = 98.0
const left         : Vector2 = Vector2(-1, 0)
const right        : Vector2 = Vector2(1, 0)
const chain_offset : Vector2 = Vector2(0, 40)

var velocity          : Vector2 = Vector2()
var rotation_velocity : float   = 0.0

var control_state

onready var tail_component : Label          = $Tail
onready var particles      : CPUParticles2D = $Particles

func _ready():
	control_state = ControlState.new()

# Frame processing

func _process():
	# Get the steering of the player and apply to rotation velocity
	rotation_velocity += control_state.rotation_direction()
	# Get thrust direction, rotate to where the player is looking and apply as velocity
	var thrust_amount = control_state.thrust_direction() * speed
	velocity += Vector2(-thrust_amount, 0).rotated(rotation)
	velocity += Vector2(0, gravity * delta) # Apply gravity
	handle_particles()

func handle_particles():
	particles.emitting = control_state.is_thrusting()
	if control_state.is_thrusting():
		particles.direction = Vector2(control_state.thrust_direction(), 0)

# Physics processing

func _physics_process(delta):
	process_rotation(delta)
	process_velocity(delta)
	handle_movement_and_collisions(delta)

func process_rotation(delta):
	rotation_velocity *= rotation_friction # Apply friction to rotation
	rotation += rotation_velocity * rotation_speed * delta

func process_velocity(delta):
	velocity *= velocity_friction # Apply friction to velocity

func handle_movement_and_collisions(delta):
	var collision = move_and_collide(velocity * delta)
	if collision: handle_collision(collision)

func handle_collision(collision):
	var collider = collision.get_collider()

	# If the colliding object doesn't have a custom collision handler, just bounce.
	if !collider.has_method("on_collide_with_player"):
		velocity = velocity.bounce(collision.normal)
		return

	var collision_result = collider.on_collide_with_player(self)
	if collision_result: emit('player_collision', collision_result)
