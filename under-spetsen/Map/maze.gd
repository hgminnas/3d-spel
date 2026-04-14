extends Node3D

signal player_hidden_status_update(is_hidden: bool)
signal controller_state_changed(new_state: Variant)

func _on_player_player_hidden_status_update(is_hidden: bool) -> void:
	emit_signal("player_hidden_status_update", is_hidden)

func _on_danger_controller_state_changed(new_state: Variant) -> void:
	emit_signal("controller_state_changed", new_state)



# --------------- JumpScare 1 -------------
func _on_area_1_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Jumpscares/Jumpscare1/Sprite2D.visible = true
		$Jumpscares/Jumpscare1/JumpScareSound1.play()
func _on_jump_scare_sound_1_finished() -> void:
	$Jumpscares/Jumpscare1/Sprite2D.visible = false


# --------------- JumpScare 2 -------------
func _on_area_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Jumpscares/Jumpscare2/Sprite2D.visible = true
		$Jumpscares/Jumpscare2/JumpScareSound2.play()
func _on_jump_scare_sound_2_finished() -> void:
	$Jumpscares/Jumpscare2/Sprite2D.visible = false


# --------------- JumpScare 3 -------------
func _on_area_3_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Jumpscares/Jumpscare3/Sprite2D.visible = true
		$Jumpscares/Jumpscare3/JumpScareSound3.play()
func _on_jump_scare_sound_3_finished() -> void:
	$Jumpscares/Jumpscare3/Sprite2D.visible = false


# --------------- JumpScare 4 -------------
func _on_area_4_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Jumpscares/Jumpscare4/JumpScareSound4.play()
func _on_jump_scare_sound_4_finished() -> void:
	null # ingen bild


# --------------- JumpScare 5 -------------
func _on_area_5_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Jumpscares/Jumpscare5/Sprite2D.visible = true
		$Jumpscares/Jumpscare5/JumpScareSound5.play()
func _on_jump_scare_sound_5_finished() -> void:
	$Jumpscares/Jumpscare5/Sprite2D.visible = false


# --------------- JumpScare 6 -------------
func _on_area_6_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Jumpscares/Jumpscare6/Sprite2D.visible = true
		$Jumpscares/Jumpscare6/JumpScareSound6.play()
func _on_jump_scare_sound_6_finished() -> void:
	$Jumpscares/Jumpscare6/Sprite2D.visible = false
