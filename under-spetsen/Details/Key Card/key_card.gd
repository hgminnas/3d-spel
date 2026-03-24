extends RigidBody3D

func _ready() -> void:
	freeze = true

func enableCard():
	freeze = false
	$SpotLight3D.visible = false
	$OmniLight3D.visible = false
