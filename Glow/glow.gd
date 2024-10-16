extends PointLight2D


@export var radius: float = 100:
	set(v):
		texture_scale = v / 298
	get:
		return texture_scale * 298

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
