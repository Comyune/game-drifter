extends RigidBody2D

onready var collision_effect = $CollisionEffect
onready var sprite           = $Sprite
onready var death_timer      = $DeathTimer

var life := 200

func _process(delta):
	life = life - delta * 200
	if life < 50: queue_free()
	if life < 100: sprite.modulate.a = life/100.0

func _ready():
	var _connection = connect("body_entered", self, "on_body_entered")
	_connection = death_timer.connect("timeout", self, "queue_free")

func on_body_entered(_body):
	sprite.visible = false
	set_sleeping(true)
	collision_effect.emitting = true
