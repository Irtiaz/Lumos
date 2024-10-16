extends CharacterBody2D

@export var SPEED: float = 3000
@export var player: CharacterBody2D
@onready var nav_agent := $CollisionShape2D.get_node('NavigationAgent2D') as NavigationAgent2D

func _ready() -> void:
	nav_agent.target_position = player.global_position
	#nav_agent.target_position = get_global_mouse_position()

func _process(delta: float) -> void:
	nav_agent.target_position = player.global_position
	$AnimatedSprite2D.flip_h = velocity.x < 0
	
	if nav_agent.distance_to_target() < 5:
		queue_free()

func _physics_process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()) - to_local($CollisionShape2D.global_position)
	velocity = dir.normalized() * SPEED * delta
	move_and_slide()
