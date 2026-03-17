extends MeshInstance3D

@onready var animation = $AnimationPlayer


func _ready():
	pass



func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		animation.play("Open")


func _on_area_3d_body_exited(body):
	if body is CharacterBody3D:
		animation.play_backwards("Open")
