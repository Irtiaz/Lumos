extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	var audio_stream_player = AudioStreamPlayer2D.new()
	audio_stream_player.stream = load("res://ui interaction.mp3")
	audio_stream_player.pitch_scale = 4
	
	audio_stream_player.connect("finished", func():
		audio_stream_player.queue_free()
		get_tree().change_scene_to_file("res://World/world.tscn")
	)
	
	add_child(audio_stream_player)
	audio_stream_player.play()
	
