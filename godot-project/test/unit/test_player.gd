extends "res://addons/gut/test.gd"
var PlayerScene = load("res://player/player.tscn")
var ControlState = load('res://player/control_state.gd')
var BubbleScene = load('res://levels/level-objects/collectables/Bubble.tscn')

const dummy_delta = 123
var _player = null

func before_each():
	_player = PlayerScene.instance()
	get_tree().root.add_child(_player)

func test_ready():
	_player._ready()
	assert_is(_player.control_state, ControlState)
	assert_connected(
		_player.control_state, _player,
		'player_shoot', 'shoot'
	)

func test_physics_process():
	_player._physics_process(dummy_delta)
	assert_eq(_player.rotation_velocity, 0.0)

func test_handle_movement_and_collisions():
	_player.handle_movement_and_collisions(dummy_delta)
	assert_eq(_player.rotation_velocity, 0.0)

func test_handle_particles():
	_player.handle_particles()
	assert_false(_player.particles.emitting)
	assert_has_method(_player.control_state, 'is_thrusting')

func test_process_rotation():
	_player.process_rotation(dummy_delta)
	assert_eq(_player.rotation_velocity, 0.0)

func test_process_velocity():
	_player.process_velocity(dummy_delta)
	assert_eq(_player.rotation_velocity, 0.0)

func test_handle_collision():
	var collision = double(KinematicCollision2D).new()
	var bubble = double(BubbleScene).instance()
	stub(collision, 'get_collider').to_return(bubble)
	_player.handle_collision(collision)
	assert_eq(_player.rotation_velocity, 0.0)
