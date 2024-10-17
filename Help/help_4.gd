extends Node2D

@onready var tilemap = $TileMapLayer as TileMapLayer
var skelephotonScene = preload("res://skelephoton/skelephoton.tscn")
var dust_scene = preload("res://Dust/dust.tscn")
var decoy_scene = preload("res://Decoy/decoy.tscn")

var has_light: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
				$NotEnoughMana/Label.show()
				$NotEnoughMana/AudioStreamPlayer2D.play()
				$NotEnoughMana/Label.self_modulate.a = 1
				$NotEnoughMana/NotEnoughManaDisplayTimer.start()
	
	elif Input.is_action_just_pressed("place_decoy"):
			
			var next_mana =  sqrt($Wizards/Player.mana ** 2 - $Wizards/Player.DECOY_COST ** 2)
			
			if $Wizards/Player.mana > $Wizards/Player.DECOY_COST && next_mana > $Wizards/Player.GAME_OVER_THRESHOLD:
				$Wizards/Player.mana = next_mana
				
				var decoy = decoy_scene.instantiate()
				decoy.position = $Wizards/Player.position
				$Wizards.add_child(decoy)
			else:
				$NotEnoughMana/Label.show()
				$NotEnoughMana/AudioStreamPlayer2D.play()
				$NotEnoughMana/Label.self_modulate.a = 1
				$NotEnoughMana/NotEnoughManaDisplayTimer.start()			


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
	
func round_to_cell_mid(coord: Vector2) -> Vector2:
	return tilemap.map_to_local(tilemap.local_to_map(coord))


func _on_flag_flag_captured() -> void:
	get_tree().change_scene_to_file("res://MainMenuScene/main_menu_scene.tscn")

func _on_button_pressed() -> void:
	var audio_stream_player = AudioStreamPlayer2D.new()
	audio_stream_player.stream = load("res://ui interaction.mp3")
	audio_stream_player.pitch_scale = 4
	
	audio_stream_player.connect("finished", func():
		audio_stream_player.queue_free()
		get_tree().change_scene_to_file("res://MainMenuScene/main_menu_scene.tscn")
	)
	
	add_child(audio_stream_player)
	audio_stream_player.play()
