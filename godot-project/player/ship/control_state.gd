extends Node

signal shoot
signal invert

const DISALLOW_ECHO = false

func _input(event):
	if event.is_action_pressed("ui_cancel", DISALLOW_ECHO):
		emit_signal("invert")
	if event.is_action_pressed("ui_accept", DISALLOW_ECHO):
		emit_signal("shoot")

func is_thrusting_forward(): return Input.is_action_pressed("ui_up")
func is_thrusting_backward(): return Input.is_action_pressed("ui_down")
func is_thrusting(): return is_thrusting_forward() or is_thrusting_backward()

func is_rotating_left(): return Input.is_action_pressed("ui_left")
func is_rotating_right(): return Input.is_action_pressed("ui_right")

func rotation_direction():
	var direction = 0
	if is_rotating_left(): direction = direction - 1
	if is_rotating_right(): direction = direction + 1
	return direction

func thrust_direction():
	var direction = 0
	if is_thrusting_forward(): direction = direction - 1
	if is_thrusting_backward(): direction = direction + 1
	return direction
