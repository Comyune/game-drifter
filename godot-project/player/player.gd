extends KinematicBody2D

export (int) var speed = 5
export (float) var rotation_speed = 0.075
export (float) var rotation_friction = 0.99
export (float) var velocity_friction = 0.99

const gravity = 98.0
const left = Vector2(-1, 0)
const right = Vector2(1, 0)

var velocity = Vector2()
var rotation_dir = 0
var tail = ''

onready var tail_component = $Tail
onready var particles = $Particles

func _physics_process(delta):
	rotation_dir *= rotation_friction
	velocity *= velocity_friction
	velocity += Vector2(0, gravity * delta)
	get_input()
	rotation += rotation_dir * rotation_speed * delta

	if are_engines_on():
		particles.emitting = true
		
		if Input.is_action_pressed('ui_up'): particles.direction = left
		else: particles.direction = right
	else: particles.emitting = false

	var collision = move_and_collide(velocity * delta)
	if !collision: return
	handle_collision(collision)

func get_input():
	if Input.is_action_pressed('ui_right'): rotation_dir += 1
	if Input.is_action_pressed('ui_left'): rotation_dir -= 1
	if Input.is_action_pressed('ui_down'):
		velocity += Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed('ui_up'):
		velocity += Vector2(speed, 0).rotated(rotation)

func are_engines_on():
	return Input.is_action_pressed('ui_up') or \
		Input.is_action_pressed('ui_down')
	
func handle_collision(collision):
	var collider = collision.collider
	
	if !collider.has_method("on_collide_with_player"):
		velocity = velocity.bounce(collision.normal)
		return
	
	var collision_result = collider.on_collide_with_player(self)
	if !collision_result: return
	
	tail.erase(0, collision_result.subtraction)
	tail = tail.insert(0, collision_result.addition)
	$Tail.text = tail
