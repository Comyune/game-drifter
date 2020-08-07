extends "res://addons/gut/test.gd"

var Player = load("res://player/player.gd")
var _player = null

func before_each():
	_player = Player.new()

func test_are_engines_on():
	assert_false(_player.are_engines_on())