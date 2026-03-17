extends Area3D

@export var value: String = "enter"

func on_clicked():
	# Find the keypad manager
	var keypad = get_parent().get_parent()  # buttons -> Buttons -> Keypad
	if keypad.has_method("handle_button"):
		keypad.handle_button(value)
