extends Node2D

func _input(event):
	if event.is_action("console_toggle"): get_tree().reload_current_scene()
