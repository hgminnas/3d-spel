extends Control

func _ready() -> void:
	$Backstory.play()


func _on_hoppa_över_pressed() -> void: # + om finished (signalen)
	get_tree().change_scene_to_file("res://Lobby/lobby.tscn")
