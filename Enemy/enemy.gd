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
	if nav_agent.is_navigation_finished():
		reset()


func _on_area_2d_area_entered(area: Area2D) -> void:
	is_awake = true
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
	is_awake = false
	position = initial_pos

func _on_death_area_area_entered(area: Area2D) -> void:
	reset()
	pass
