extends Node3D

signal can_not_move(if_move : bool)

@onready var blackScreen = $BlackScreen

var got_caught = true

func _on_start_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$HuntingYou.play()
		$ToGetCaught.start()

func _on_to_get_caught_timeout() -> void:
	if got_caught:
		get_tree().change_scene_to_file("res://Lobby/DeadScreen/dead_screen.tscn") # Got caught
	
	
func _on_killing_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		got_caught = false
		$HuntingYou.stop()
		$DeadVoice.play()

		blackScreen.visible = true
		blackScreen.modulate.a = 0 
		var tween = get_tree().create_tween()
		tween.tween_property(blackScreen, "modulate:a", 1.0, 0.4)

		emit_signal("can_not_move", true)


func _on_to_dead_screen_timeout() -> void:
	get_tree().change_scene_to_file("res://Lobby/DeadScreen/dead_screen.tscn")
