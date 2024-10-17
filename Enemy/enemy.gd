extends CharacterBody2D

@export var SPEED: float = 3000
@export var player: CharacterBody2D
@export var wizards: Node

@onready var nav_agent := $CollisionShape2D.get_node('NavigationAgent2D') as NavigationAgent2D
@onready var initial_pos = position


var is_awake = false

func makepath() -> void:
	var winner_pos = null
	var winner_dist: float
	for wizard in wizards.get_children():
		nav_agent.target_position = wizard.position
		var dist = nav_agent.distance_to_target()
		if winner_pos == null or dist < winner_dist:
			winner_pos = wizard.position
			winner_dist = dist
	nav_agent.target_position = winner_pos

func _ready() -> void:
	#nav_agent.target_position = player.get_node('CollisionShape2D').global_position
	#nav_agent.target_position = get_global_mouse_position()
	makepath()

func _process(delta: float) -> void:
	if !is_awake:
		return
	#nav_agent.target_position = player.get_node('CollisionShape2D').global_position
	
	$AnimatedSprite2D.flip_h = velocity.x < 0
	
	#if nav_agent.distance_to_target() < 5:
		#queue_free()

func _physics_process(delta: float) -> void:
	if !is_awake:
		return
	makepath()
	var dir = to_local(nav_agent.get_next_path_position()) - to_local($CollisionShape2D.global_position)
	velocity = dir.normalized() * SPEED * delta
	move_and_slide()
	#if nav_agent.is_navigation_finished():
		#reset()


func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if is_awake: return
	
	is_awake = true
	
	var animated_sprite := AnimatedSprite2D.new()
	var sprite_frames := SpriteFrames.new()
	
	animated_sprite.material = CanvasItemMaterial.new()
	animated_sprite.material.light_mode = 1
	animated_sprite.z_index = 100
	animated_sprite.scale *= 1
	
	sprite_frames.add_animation("alert")
	sprite_frames.set_animation_speed("alert", 10)
	for i in 8:
		sprite_frames.add_frame("alert", load("res://Enemy/alert" + str(i + 1) + ".png"))
	
	sprite_frames.set_animation_loop("alert", false)
	
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.animation = "alert"
	
	animated_sprite.position = Vector2(0, 0)
	
	animated_sprite.connect("animation_finished", func():
		print("Done animating alert!")
		animated_sprite.queue_free()
	)
	
	add_child(animated_sprite)
	animated_sprite.play()
	
	##show()
	#light_count += 1
	#
	##if light_count >= 1:
		##show()
	##else:
		##hide()
#
#func _on_area_2d_area_exited(area: Area2D) -> void:
	#light_count -= 1
	#
	##if light_count >= 1:
		##show()
	##else:
		##hide()

func reset() -> void:
	#queue_free()
	#light_count = 0
	#hide()
	
	var animated_sprite := AnimatedSprite2D.new()
	var sprite_frames := SpriteFrames.new()
	
	animated_sprite.material = CanvasItemMaterial.new()
	animated_sprite.material.light_mode = 1
	animated_sprite.modulate.g = 200
	
	sprite_frames.add_animation("vanish")
	sprite_frames.set_animation_speed("vanish", 5)
	for i in 8:
		sprite_frames.add_frame("vanish", load("res://Enemy/vanish" + str(i + 1) + ".png"))
	
	sprite_frames.set_animation_loop("vanish", false)	
	
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.animation = "vanish"
	
	animated_sprite.position = Vector2(position) + Vector2(0, 10)
	
	animated_sprite.connect("animation_finished", func():
		animated_sprite.queue_free()
	)
	
	get_parent().add_child(animated_sprite)
	animated_sprite.play()

	is_awake = false
	position = initial_pos
	


func _on_player_death_area_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	player.mana = sqrt(player.mana ** 2 - player.ENEMY_DAMAGE ** 2)
	
	reset()


func _on_decoy_death_area_area_entered(area: Area2D) -> void:
	reset()
