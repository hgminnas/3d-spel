extends MeshInstance3D

@export var spin_degrees := 45     # how much it spins
@export var spin_time := 0.5       # time it takes to spin

var spinning := false
var start_rot: Basis
var target_rot: Basis
var timer := 0.0

func _ready():
	pass

func on_clicked():
	if spinning:
		return
	start_rot = global_transform.basis
	target_rot = start_rot.rotated(Vector3.UP, deg_to_rad(spin_degrees))
	timer = 0.0
	spinning = true

func _process(delta):
	if spinning:
		timer += delta
		var t = clamp(timer / spin_time, 0, 1)
		global_transform.basis = start_rot.slerp(target_rot, t)
		if t >= 1:
			spinning = false
