extends Node2D

var skelephotonScene = preload("res://skelephoton/skelephoton.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (Input.is_action_just_pressed("spawn_skelephoton")):
		var skelephoton = skelephotonScene.instantiate()
		skelephoton.player = $Player
		skelephoton.position = get_global_mouse_position()
		add_child(skelephoton)
	
	pass
