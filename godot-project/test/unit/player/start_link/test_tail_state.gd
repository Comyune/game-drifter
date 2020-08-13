extends "res://addons/gut/test.gd"
var TailState = load("res://types/tail_state.gd")
var CollisionResult = load("res://types/collision_result.gd")

var _tail_state = null

func before_each():
	_tail_state = TailState.new()

func test_initialization():
	assert_eq(_tail_state.get_contents(), '')

func test_size():
	assert_eq(_tail_state.size(), 0)

func test_invert():
	_tail_state.set_contents('ABC')
	_tail_state.invert()
	assert(_tail_state.get_contents(), 'CBA')

func test_update_with_collision_result():
	var collision_result = CollisionResult.new()
	collision_result.set_addition('A')
	_tail_state.update_with_collision_result(collision_result)
	assert_eq(_tail_state.get_contents(), 'A')
	collision_result.set_addition('B')
	_tail_state.update_with_collision_result(collision_result)
	assert_eq(_tail_state.get_contents(), 'AB')
	assert_eq(_tail_state.size(), 2)
