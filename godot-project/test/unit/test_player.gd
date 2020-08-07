extends "res://addons/gut/test.gd"
var ControlState = load('res://player/control_state.gd')

const dummy_delta = 123.0

var Player = load("res://player/player.gd")
var _player = null

func before_each(): _player = autofree(Player.new())

func test_ready():
	_player.ready()
	assert_is(_player.control_state, ControlState)

func test_physics_process():
	_player.physics_process(dummy_delta)
	assert_eq(_player.rotation_velocity, 0)

func test_handle_movement_and_collisions():
	_player.handle_movement_and_collisions(dummy_delta)
	assert_eq(_player.rotation_velocity, 0)

func test_handle_particles():
	_player.handle_particles()
	assert_false(_player.particles.emitting)
	stub(
		_player.control_state, 'is_thrusting'
	).to_return(true)
	_player.handle_particles()
	assert(_player.particles.emitting)

func test_process_rotation():
	_player.process_rotation(dummy_delta)
	assert_eq(_player.rotation_velocity, 0)

func test_process_velocity():
	_player.process_velocity(dummy_delta)
	assert_eq(_player.rotation_velocity, 0)

func test_handle_collision():
	var collision = KinematicCollision2D.new()
	_player.handle_collision(collision)
	assert_eq(_player.rotation_velocity, 0)
