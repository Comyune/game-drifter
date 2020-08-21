extends AnimatedSprite

const total_frames := 8

func _process(_delta):
	if frame > total_frames: queue_free()
	var half_frames = total_frames / 2.0
	if frame < half_frames: return
	modulate.a = (half_frames - frame) / half_frames
