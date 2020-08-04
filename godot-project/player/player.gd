extends KinematicBody2D

signal collided_with(object)

export (int) var speed = 5
export (float) var rotation_speed = 0.075
export (float) var rotation_friction = 0.99
export (float) var velocity_friction = 0.99

var velocity = Vector2()
var rotation_dir = 0
var tail = ''

onready var tail_component = $Tail

func _physics_process(delta):
	rotation_dir *= rotation_friction
	velocity *= velocity_friction
	get_input()
	rotation += rotation_dir * rotation_speed * delta
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
