extends Node2D

var skelephotonScene = preload("res://skelephoton/skelephoton.tscn")
@onready var tilemap = $TileMapLayer as TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if (Input.is_action_just_pressed("spawn_skelephoton")):
		var cell_coord = tilemap.local_to_map(get_local_mouse_position())
		var safe_coord = find_nearest_cell(cell_coord)
		
		if safe_coord == Vector2i(-1, -1): return
		
		var skelephoton = skelephotonScene.instantiate()
		skelephoton.player = $Player
		skelephoton.position = tilemap.map_to_local(safe_coord)
		add_child(skelephoton)
	
	pass

func is_safe(cell_coord: Vector2i) -> bool:
	return tilemap.get_cell_atlas_coords(cell_coord) == Vector2i(1, 4)

func find_nearest_cell(cell_coord: Vector2i) -> Vector2i:
	const list: Array[Vector2i] = [
		Vector2i(0, 0),
		Vector2i(-1, 0),
		Vector2i(1, 0),
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(1, 1),
		Vector2i(1, -1),
		Vector2i(-1, 1),
		Vector2i(-1, -1)
	]
	
	for offset in list:
		var current_coord = cell_coord + offset
		if is_safe(current_coord): return current_coord
	return Vector2i(-1, -1)
	
