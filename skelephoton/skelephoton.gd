extends CharacterBody2D

@export var SPEED: float = 3000
@onready var nav_agent := $CollisionShape2D.get_node('NavigationAgent2D') as NavigationAgent2D
@export var target: Vector2;


func _ready() -> void:
	nav_agent.target_position = target
	#nav_agent.target_position = get_global_mouse_position()

func _process(delta: float) -> void:
	$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if nav_agent.distance_to_target() < 5:
		queue_free()

func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()) - to_local($CollisionShape2D.global_position)
	velocity = dir.normalized() * SPEED * delta
	move_and_slide()


func _on_consume_area_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	var gain = player.SKELEPHOTON_COST * player.SKELEPHOTON_GAIN_QUANTILE
	player.mana = sqrt(player.mana ** 2 + gain ** 2)
	
	var animated_sprite := AnimatedSprite2D.new()
	var sprite_frames := SpriteFrames.new()
	
	animated_sprite.material = CanvasItemMaterial.new()
	animated_sprite.material.light_mode = 1
	animated_sprite.z_index = 100
	animated_sprite.scale /= 3
	
	sprite_frames.add_animation("shine")
	sprite_frames.set_animation_speed("shine", 50)
	for i in 10:
		sprite_frames.add_frame("shine", load("res://skelephoton/shine" + str(i + 1) + ".png"))
	
	sprite_frames.set_animation_loop("shine", false)	
	
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.animation = "shine"
	
	animated_sprite.position = Vector2(position) + Vector2(5, 0)
	
	animated_sprite.connect("animation_finished", func():
		animated_sprite.queue_free()
	)
	
	get_parent().add_child(animated_sprite)
	animated_sprite.play()
	
	$AudioStreamPlayer2D.stop()
	
	var audio_stream_player = AudioStreamPlayer2D.new()
	audio_stream_player.stream = load("res://skelephoton/photondeath.mp3")
	
	audio_stream_player.connect("finished", func():
		audio_stream_player.queue_free()
	)
	
	get_parent().get_parent().add_child(audio_stream_player)
	audio_stream_player.play()
	
	
	queue_free()
