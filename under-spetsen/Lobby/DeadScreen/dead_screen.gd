extends Node3D

@onready var text = $DeadScreen/Label

func _ready() -> void:
	$DeadScreen/ToTextArrive.start()
	$DeadScreen/ToBackToLobby.start()

func _on_to_text_arrive_timeout() -> void:
	text.visible = true
	text.modulate.a = 0 
	var tween = get_tree().create_tween()
	tween.tween_property(text, "modulate:a", 1.0, 0.4)
	
func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Lobby/lobby.tscn")
