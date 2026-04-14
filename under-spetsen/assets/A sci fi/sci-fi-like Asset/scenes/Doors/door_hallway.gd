extends MeshInstance3D

@onready var animation = $AnimationPlayer

var counterOpen = 0
var counterClose = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body is CharacterBody3D and counterOpen < 1:
		animation.play("Open")
		$Door_Big_2/DoorSound.play()
		counterOpen += 1
		$StaticBody3D/CollisionShape3D.disabled = true



func _on_area_3d_body_exited(body):
	if body is CharacterBody3D and counterClose < 1:
		animation.play_backwards("Open")
		$Door_Big_2/DoorSound.play()
		counterClose += 1
		$StaticBody3D/CollisionShape3D.disabled = false
		
