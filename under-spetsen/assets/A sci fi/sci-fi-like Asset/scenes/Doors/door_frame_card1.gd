extends MeshInstance3D

@onready var animation = $AnimationPlayer


func _ready():
	pass



func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("card"):
		$"Open Close Sound".play()
		animation.play("Open")


func _on_area_3d_body_exited(body):
	if body.is_in_group("card"):
		$"Open Close Sound".play()
		animation.play_backwards("Open")
