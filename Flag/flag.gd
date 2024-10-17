extends Sprite2D

signal flag_captured

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_win_area_area_entered(area: Area2D) -> void:
	flag_captured.emit()
