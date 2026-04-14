extends RigidBody3D

signal tower_state(is_correct)

var list = []

var correct = {
	"cube": false,
	"triangle": false,
	"rectangle": false,
	"barrel": false
}
func _ready() -> void:
	$SpotLight3D.light_color = "ff0000" # Red
	$MeshInstance3D.set_instance_shader_parameter("color", Color(0.694, 0.125, 0.0, 1.0))
	

# 1:st piece; Cube
func _on__cube_body_entered(body: Node3D) -> void:
	#print(body.name)
	#print(body.get_groups())
	if body.is_in_group("cube"):
		correct["cube"] = true
		is_correct()

func _on__cube_body_exited(body: Node3D) -> void:
	if body.is_in_group("cube"):
		correct["cube"] = false



# 2:nd piece; Triangle
func _on__triangle_body_entered(body: Node3D) -> void:
	if body.is_in_group("triangle"):
			correct["triangle"] = true
			is_correct()

func _on__triangle_body_exited(body: Node3D) -> void:
	if body.is_in_group("triangle"):
			correct["triangle"] = false


# 3:rd piece; Triangle
func _on__rectangle_body_entered(body: Node3D) -> void:
	if body.is_in_group("rectangle"):
			correct["rectangle"] = true
			is_correct()

func _on__rectangle_body_exited(body: Node3D) -> void:
	if body.is_in_group("rectangle"):
			correct["rectangle"] = false


# 4:th piece; Barrel
func _on__barrel_body_entered(body: Node3D) -> void:
	if body.is_in_group("barrel"):
			correct["barrel"] = true
			is_correct()

func _on__barrel_body_exited(body: Node3D) -> void:
	if body.is_in_group("barrel"):
			correct["barrel"] = false


func is_correct():
	var is_correct = true
	for piece in correct:
		if correct[piece] == false:
			is_correct = false
			break
	#print("Tower is ", is_correct)
	#print_current_state()
	light(is_correct)
	return is_correct
	
#func print_current_state():
#	print("--------------------------")
#	for piece in correct:
#		print(piece, ": ", correct[piece])
#	print("--------------------------")

	
func light(set_state: bool):
	if set_state:
		$SpotLight3D.light_color = "00ff00" # Green
		$MeshInstance3D.set_instance_shader_parameter("color", Color(0, 1, 0))
		emit_signal("tower_state", set_state)
		$Correct.play()
	else:
		$SpotLight3D.light_color = "ff0000" # Red
		$MeshInstance3D.set_instance_shader_parameter("color", Color(0.694, 0.125, 0.0, 1.0))
		emit_signal("tower_state", set_state)
	
