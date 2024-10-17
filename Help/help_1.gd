extends Node2D


@onready var tilemap = $TileMapLayer as TileMapLayer
var dust_scene = preload("res://Dust/dust.tscn")
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


func _on_flag_flag_captured() -> void:
	get_tree().change_scene_to_file("res://Help/help_2.tscn")
	
	
func round_to_cell_mid(coord: Vector2) -> Vector2:
	return tilemap.map_to_local(tilemap.local_to_map(coord))


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
