extends Node
onready var SceneMode = $"/root/SceneMode"
onready var start_link = $StartLink

func _input(event):
	if !SceneMode.on(): return
	if !(event is InputEventKey && event.pressed): return
	if event.scancode == KEY_SPACE: start_link.create_link('A')

