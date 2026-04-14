extends MeshInstance3D

signal correct_code(is_correct : bool)

@export var display_label: Label3D  
var input_string := ""

func _ready():
	add_to_group("keypad")
	display_label = $Display

func handle_button(value: String):
	$ButtonSound.play()
	match value:
		"enter":
			check_code()
		"back":
			if input_string.length() > 0:
				input_string = input_string.substr(0, input_string.length() - 1)
		_:
			if !input_string.is_valid_int():
				input_string = ""
				display_label.modulate = Color(1, 1, 1)
			
			if input_string.length() == 3:
				input_string += value
				check_code()
			else:
				input_string += value


	display_label.text = input_string

	print("Current input:", input_string)

func check_code():
	if input_string == "8973":
		#print("Correct code!")
		input_string = "Success"
		display_label.modulate = Color(0.0, 0.904, 0.0, 1.0)
		$Correct.play()
		emit_signal("correct_code", true)
	else:
		#print("Wrong code")
		input_string = "WRONG"
		display_label.modulate = Color(0.772, 0.08, 0.171, 1.0)
		$Wrong.play()
		emit_signal("correct_code", false)
		
