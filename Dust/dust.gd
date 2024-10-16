extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = randi() % 4
	scale = Vector2(1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	if scale.x <= 0.1:
		scale = Vector2(0, 0)
		$Timer.stop()
	else:
		scale *= 0.96
