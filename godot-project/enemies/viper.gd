extends RigidBody2D

const MAX_PATIENCE := 200.0

export (float) var slow_impulse := 15.0
export (float) var thrust_impulse := 20.0
export (float) var spin_impulse := 200.0
export (float) var stabilization_factor := 1.0

onready var navigation_ray_l = $NavigationRayL
onready var navigation_ray_r = $NavigationRayR
onready var navigation_ray_b = $NavigationRayB
onready var particles_l      = $ParticlesL
onready var particles_r      = $ParticlesR

var patience := 100.0

func _integrate_forces(state : Physics2DDirectBodyState):
	patience = clamp(patience - 1, 0, MAX_PATIENCE)
	if no_rays_colliding(): return full_thrust()
	if patience < 10: return go_crazy(state)
	if patience < 50: return pause()

	if both_rays_colliding(): return slow_and_spin(state)
	if navigation_ray_l.is_colliding(): spin_right()
	if navigation_ray_r.is_colliding(): spin_left()

func go_crazy(_state):
	if rand_range(0, 100) > 90:
		apply_torque_impulse(rand_range(-2000, 2000))

	if rand_range(0, 100) > 90:
		apply_impulse(
			Vector2.ZERO, Vector2(0, rand_range(-200, 200)).rotated(rotation)
		)

func pause(): pass

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
