extends CharacterBody2D


@export var SPEED: float = 4000
@export var SKELEPHOTON_COST := 10
@export var SKELEPHOTON_GAIN_QUANTILE := 0.8
@export var ENEMY_DAMAGE := 30
@export var DECOY_COST := 40

@export var mana: float = 200:
	set(v):
		$Glow.radius = v
	get:
		return $Glow.radius

func _ready() -> void:
	$Glow.radius = mana

func _process(delta: float) -> void:
	if velocity.length() == 0:
		$AnimatedSprite2D.play('idle')
	else:
		$AnimatedSprite2D.play('run')
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	# Movement input detection
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

	# Normalize the velocity vector if moving diagonally
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED * delta

	# Apply the movement
	move_and_slide()
