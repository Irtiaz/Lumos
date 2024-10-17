extends Node2D

var skelephotonScene = preload("res://skelephoton/skelephoton.tscn")
var dust_scene = preload("res://Dust/dust.tscn")
var decoy_scene = preload("res://Decoy/decoy.tscn")

@onready var tilemap = $TileMapLayer as TileMapLayer

var has_light: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_nan($Wizards/Player.mana) || $Wizards/Player.mana <= 16:
		$GameOverControls.show()
		$Wizards/Player.GAME_OVER = true
		$Wizards/Player.mana = 0
	
	var mid_coord = round_to_cell_mid($Wizards/Player/CollisionShape2D.global_position)
	if !has_light.has(mid_coord):
		#print(mid_coord)
		
		var dust = dust_scene.instantiate()
		dust.position = mid_coord
		dust.z_index = -1
		add_child(dust)
		
		has_light[mid_coord] = dust
	
	else:
		has_light[mid_coord].scale = Vector2(1, 1)
		has_light[mid_coord].get_node("Timer").start()
		
	
	if !$Wizards/Player.GAME_OVER:
	
		if Input.is_action_just_pressed("spawn_skelephoton"):
			var cell_coord = tilemap.local_to_map(get_local_mouse_position())
			var safe_coord = find_nearest_cell(cell_coord)
			
			if safe_coord == Vector2i(-1, -1): return
			
			var next_mana = sqrt($Wizards/Player.mana ** 2 - $Wizards/Player.SKELEPHOTON_COST ** 2)
			
			if $Wizards/Player.mana > $Wizards/Player.SKELEPHOTON_COST && next_mana > $Wizards/Player.GAME_OVER_THRESHOLD:
				$Wizards/Player.mana = next_mana
				
				var skelephoton = skelephotonScene.instantiate()
				skelephoton.target = $Wizards/Player/CollisionShape2D.global_position
				skelephoton.position = tilemap.map_to_local(safe_coord)
				add_child(skelephoton)
				
			else:
				print("Not enough mana to spawn skelephoton")
		
		elif Input.is_action_just_pressed("place_decoy"):
			
			var next_mana =  sqrt($Wizards/Player.mana ** 2 - $Wizards/Player.DECOY_COST ** 2)
			
			if $Wizards/Player.mana > $Wizards/Player.DECOY_COST && next_mana > $Wizards/Player.GAME_OVER_THRESHOLD:
				$Wizards/Player.mana = next_mana
				
				var decoy = decoy_scene.instantiate()
				decoy.position = $Wizards/Player.position
				$Wizards.add_child(decoy)
			else:
				print("Not enough mana to palce decoy")
		
	
	pass

func round_to_cell_mid(coord: Vector2) -> Vector2:
	return tilemap.map_to_local(tilemap.local_to_map(coord))

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
	


func _on_try_again_button_pressed() -> void:
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
