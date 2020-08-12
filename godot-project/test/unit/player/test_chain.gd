extends "res://addons/gut/test.gd"
var ChainScene = preload("res://player/chain/chain.tscn")

var _chain = null

func before_each():
	_chain = ChainScene.instance()
	get_tree().root.add_child(_chain)

func test_ready():
	assert_false(_chain.scene_mode)
