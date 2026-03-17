extends Node3D

var tower_state = {
	"tower1" : false,
	"tower2" : false
}

func _ready() -> void:
	$KeyCard.visible = false
	$KeyCard/CollisionShape3D.disabled = true
	$KeyCard/SpotLight3D.visible = false
	

func _on_panel_light_tower_state(is_correct: bool) -> void:
	#print("----------------------")
	#print("Tower 1", is_correct)
	tower_state["tower1"] = is_correct
	is_correct()


func _on_panel_light_2_tower_state_2(is_correct: bool) -> void:
	#print("----------------------")
	#print("Tower 2", is_correct)
	tower_state["tower2"] = is_correct
	is_correct()
	

func is_correct() -> bool:
	var is_correct = true
	for tower in tower_state:
		if tower_state[tower] == false:
			is_correct = false
			break
	#print("Tower is ", is_correct)
	
	if is_correct:
		card_appear()
	
	return is_correct

func card_appear():
	$KeyCard.visible = true
	$KeyCard/CollisionShape3D.disabled = false
	$KeyCard/SpotLight3D.visible = true

	
	
