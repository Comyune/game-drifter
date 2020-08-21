extends RigidBody2D

const Bullet    = preload("res://enemies/projectiles/bullet.tscn")
const Explosion = preload("res://effects/explosion.tscn")

const MAX_PATIENCE := 100.0
const ENVIRONMENT_COLLISION_LAYER := 2

export (float) var slow_impulse := 10.0
export (float) var thrust_impulse := 12.0
export (float) var spin_impulse := 200.0
export (float) var stabilization_factor := 1.0
export (float) var bullet_speed := 1500.0

onready var navigation_ray_l = $NavigationRayL
onready var navigation_ray_r = $NavigationRayR
onready var navigation_ray_b = $NavigationRayB
onready var navigation_ray_f = $NavigationRayF
onready var shoot_cooldown   = $ShootCooldown
onready var particles_l      = $ParticlesL
onready var particles_r      = $ParticlesR
onready var sight            = $Sight

var patience := 100.0
var can_shoot := true
var goal = null

func _ready():
	shoot_cooldown.connect("timeout", self, "on_shoot_cooldown_timeout")
	sight.connect("body_entered", self, "on_sight_body_entered")
	sight.connect("body_exited", self, "on_sight_body_exited")

func _process(_delta):
	if can_shoot and navigation_ray_f.is_colliding():
		var collider = navigation_ray_f.get_collider()

		# Don't bother shooting if we'd hit a wall
		if collider.get_collision_layer_bit(ENVIRONMENT_COLLISION_LAYER):
			return

		shoot()

func shoot():
	can_shoot = false
	shoot_cooldown.start()
	var bullet = Bullet.instance()
	bullet.transform = transform
	bullet.apply_central_impulse(Vector2(0, -bullet_speed).rotated(rotation))
	get_parent().add_child(bullet)

func die():
	var explosion = Explosion.instance()
	explosion.position = position
	get_parent().add_child(explosion)
	explosion.play()
	queue_free()

func _integrate_forces(state : Physics2DDirectBodyState):
	patience = clamp(patience - 1, 0, MAX_PATIENCE)
	if goal: chase()
	if no_rays_colliding(): return full_thrust()
	if patience < 10: return go_crazy(state)
	if patience < 50: return engines_off()

	if both_rays_colliding(): return slow_and_spin(state)
	if navigation_ray_l.is_colliding(): spin_right()
	if navigation_ray_r.is_colliding(): spin_left()

# Steer towards whatever our goal is
func chase():
	var direction = position.direction_to(goal.position).angle() + PI/2
	var impulse = lerp_angle(rotation, direction, 1.0)
	apply_torque_impulse((rotation - impulse) * -spin_impulse)

func go_crazy(_state):
	if rand_range(0, 100) > 90:
		apply_torque_impulse(rand_range(-2000, 2000))

	if rand_range(0, 100) > 90:
		apply_impulse(
			Vector2.ZERO, Vector2(0, rand_range(-200, 200)).rotated(rotation)
		)

func engines_off():
	particles_l.emitting = false
	particles_r.emitting = false

func both_rays_colliding() -> bool:
	return navigation_ray_l.is_colliding() and navigation_ray_r.is_colliding()

func no_rays_colliding() -> bool:
	return !navigation_ray_l.is_colliding() and !navigation_ray_r.is_colliding()

func slow_and_spin(state : Physics2DDirectBodyState) -> void:
	if !navigation_ray_b.is_colliding():
		apply_impulse(Vector2.ZERO, Vector2(0, slow_impulse).rotated(rotation))

	apply_torque_impulse(-state.angular_velocity * stabilization_factor)
	particles_l.emitting = false
	particles_r.emitting = false
	if state.angular_velocity == 0: return
	if state.angular_velocity > 0: spin_right()
	else: spin_left()

func full_thrust():
	apply_impulse(Vector2.ZERO, Vector2(0, -thrust_impulse).rotated(rotation))
	particles_l.emitting = true
	particles_r.emitting = true
	patience = clamp(patience + 2, 0, MAX_PATIENCE)

func spin_right():
	particles_l.emitting = true
	particles_r.emitting = false
	apply_torque_impulse(spin_impulse)

func spin_left():
	particles_l.emitting = false
	particles_r.emitting = true
	apply_torque_impulse(-spin_impulse)

# Handlers

func on_shoot_cooldown_timeout(): can_shoot = true
func on_sight_body_entered(body): goal = body
func on_sight_body_exited(_body): goal = null
