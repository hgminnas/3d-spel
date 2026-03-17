extends Area3D

func _ready():
	# Connect the input_event to a local method
	connect("input_event", Callable(self, "_on_area_input"))

func _on_area_input(camera, event, click_position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		get_parent().on_clicked()
