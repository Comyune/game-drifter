extends Object

signal player_shoot
signal player_invert

func _input(event):
	if event is InputEventKey:
		if event.is_action("ui_cancel"): emit_signal('player_invert')
		if event.is_action("ui_accept"): emit_signal('player_shoot')

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
