extends Node3D

const SENSITIVITY = 0.2
const HOLD_DISTANCE = 2.5
const HOLD_STRENGTH = 12.0

@onready var cam = $Camera3D
@onready var ray = $Camera3D/RayCast3D

var held_object: RigidBody3D = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	# -------- FPS LOOK --------
	if event is InputEventMouseMotion:
		get_parent().rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))

	# -------- CLICK BUTTONS --------
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if ray.is_colliding():
			var obj = ray.get_collider()
			#print(obj)
			if obj.has_method("on_clicked"):
				obj.on_clicked()

	# -------- PICKUP / DROP --------
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		if held_object:
			drop_object()
		else:
			try_pickup()


func try_pickup():

	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj is RigidBody3D and obj.is_in_group("pickup"):
			
			if obj is RigidBody3D and obj.is_in_group("card"): # Card
				obj.enableCard()
			
			held_object = obj
			held_object.gravity_scale = 0
			held_object.linear_velocity = Vector3.ZERO
			held_object.angular_velocity = Vector3.ZERO


func drop_object():
	if held_object:
		held_object.gravity_scale = 1
		held_object = null


func _physics_process(delta):
	if held_object:
		var target_position = cam.global_transform.origin + (-cam.global_transform.basis.z * HOLD_DISTANCE)
		var direction = target_position - held_object.global_transform.origin
		
		held_object.linear_velocity = direction * HOLD_STRENGTH
