extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Glow.radius <= 2:
		var animated_sprite := AnimatedSprite2D.new()
		var sprite_frames := SpriteFrames.new()
		
		animated_sprite.material = CanvasItemMaterial.new()
		animated_sprite.material.light_mode = 1
		animated_sprite.z_index = 100
		
		sprite_frames.add_animation("decoy")
		sprite_frames.set_animation_speed("decoy", 20)
		for i in 7:
			sprite_frames.add_frame("decoy", load("res://Decoy/decoy" + str(i + 1) + ".png"))
		
		sprite_frames.set_animation_loop("decoy", false)	
		
		animated_sprite.sprite_frames = sprite_frames
		animated_sprite.animation = "decoy"
		
		animated_sprite.position = Vector2(position)
		
		animated_sprite.connect("animation_finished", func():
			animated_sprite.queue_free()
		)
		
		get_parent().get_parent().add_child(animated_sprite)
		animated_sprite.play()
		
		var audio_stream_player = AudioStreamPlayer2D.new()
		audio_stream_player.stream = load("res://Decoy/decoy death.mp3")
		
		audio_stream_player.connect("finished", func():
			audio_stream_player.queue_free()
		)
		
		get_parent().get_parent().add_child(audio_stream_player)
		audio_stream_player.play()
		
		
		queue_free()
	else:
		$Glow.radius -= 7 * delta
