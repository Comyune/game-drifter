extends "res://addons/gut/test.gd"
var CollisionResult = load("res://types/collision_result.gd")

var _collision_result = null

func before_each():
	_collision_result = CollisionResult.new()

func test_setting_and_getting_addition():
	_collision_result.set_addition('ABC')
	assert_eq(_collision_result.get_addition(), 'ABC')

func test_setting_and_getting_subtraction():
	_collision_result.set_subtraction(10)
	assert_eq(_collision_result.get_subtraction(), 10)
