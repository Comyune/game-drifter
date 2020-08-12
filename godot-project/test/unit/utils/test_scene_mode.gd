extends "res://addons/gut/test.gd"
var SceneMode = preload("res://utils/scene_mode.gd")

var _scene_mode = null

func before_each():
	_scene_mode = $"/root/SceneMode"

func test_autoload_initialization():
	assert_is(_scene_mode, SceneMode)

func test_is_scene():
	assert_false(_scene_mode.on())
