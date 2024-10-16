extends PointLight2D

const factor := 0.75

@export var radius: float = 100:
	set(v):
		texture_scale = v / 50
		$Area2D/CollisionShape2D.shape = CircleShape2D.new()
		$Area2D/CollisionShape2D.shape.set_radius(radius * factor)
	get:
		return texture_scale * 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D/CollisionShape2D.shape = CircleShape2D.new()
	$Area2D/CollisionShape2D.shape.set_radius(radius * factor)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
