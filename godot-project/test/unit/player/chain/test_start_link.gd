extends "res://addons/gut/test.gd"
var StartLink = preload("res://player/chain/start_link.tscn")

var _start_link = null

func before_each():
	_start_link = StartLink.instance()
	get_tree().root.add_child(_start_link)
