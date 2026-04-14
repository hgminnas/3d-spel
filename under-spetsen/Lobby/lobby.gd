extends Node3D

@onready var clickAudio = $Lobby/Text/clickSound

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_spela_pressed() -> void:
	clickAudio.play()
	get_tree().change_scene_to_file("res://Map/basement.tscn")


func _on_avsluta_pressed() -> void:
	get_tree().quit()


func _on_kontroller_pressed() -> void:
	clickAudio.play()
	$Lobby/Kontroller.visible = true


func _on_tillbaka_pressed() -> void:
		clickAudio.play()
		$Lobby/Kontroller.visible = false


func _on_backstory_pressed() -> void:
	$"Lobby/Backstory Control".visible = true
	$AudioStreamPlayer.stop()
	$"Lobby/Backstory Control/Backstory".play()


func _on_audio_stream_player_finished() -> void:
	$"Lobby/Backstory Control".visible = false
	$AudioStreamPlayer.play()
	$"Lobby/Backstory Control/Backstory".stop()
