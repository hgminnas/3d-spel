extends Control

signal pause_state(is_paused : bool)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		print("Esc clicked")
		if get_tree().paused:
			close_pause()
			print("close_pause()")
		else:
			open_pause()
			print("open_pause")

func open_pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	visible = true
	emit_signal("pause_state", true)
	get_tree().paused = true

func close_pause():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	emit_signal("pause_state", false)
	get_tree().paused = false

func _on_spela_pressed() -> void:
	close_pause()


func _on_avsluta_pressed() -> void:
	get_tree().quit()
