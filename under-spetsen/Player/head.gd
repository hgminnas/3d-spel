extends Node3D

signal player_hidden_status_update(is_hidden: bool)


var SENSITIVITY = 0.2
const HOLD_DISTANCE = 2.5
const HOLD_STRENGTH = 12.0

@onready var cam = $Camera3D
@onready var ray = $Camera3D/RayCast3D
@onready var hide_canvas = $HideCanvas
@onready var hide_screen = $HideCanvas/HideScreen

var held_object: RigidBody3D = null


var hid: bool = false

enum MazeState {
	IDLE, # cooldown
	ACTIVE, # being chased
	HIDING
}

var maze_hiding_state = MazeState.IDLE

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide_screen.visible = false


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
	
	
	# --------- HIDERS -----------
	if event is InputEventKey and event.pressed and event.keycode == KEY_Q:
		if hid:
			stop_hide()
		else:
			player_hide()


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
		held_object.apply_impulse(Vector3.ZERO, Vector3.DOWN * 2.0)
		held_object = null


func stop_hide():
	if hid and maze_hiding_state != MazeState.ACTIVE:
		get_parent().ACCELERATION = 1.76
		get_parent().JUMP_VELOCITY = 6.5
		SENSITIVITY = 0.2
		
		hide_screen.modulate.a = 1 # should not be needed 
		var tween = get_tree().create_tween()
		tween.tween_property(hide_screen, "modulate:a", 0.0, 0.4)
		tween.tween_callback(hide_screen.hide) # hide on tween finish

		hid = false
		emit_signal("player_hidden_status_update", false)


func player_hide():
	#print("player_hide on run")
	if ray.is_colliding():
		var hide_obj = ray.get_collider()
		#print("var hide_obj succed")
		#print(hide_obj)
		
		if hide_obj.is_in_group("hider"):
			print("hide_obj in hider")
			get_parent().ACCELERATION = 0
			get_parent().JUMP_VELOCITY = 0
			SENSITIVITY = 0
			
			hide_screen.visible = true
			hide_screen.modulate.a = 0 
			var tween = get_tree().create_tween()
			tween.tween_property(hide_screen, "modulate:a", 1.0, 0.4)
 
			
			hid = true
			emit_signal("player_hidden_status_update", true)
			#print("hid = true")
			$"Hiding sound".play()


func _physics_process(delta):
	if held_object:
		var target_position = cam.global_transform.origin + (-cam.global_transform.basis.z * HOLD_DISTANCE)
		var direction = target_position - held_object.global_transform.origin
		
		held_object.linear_velocity = direction * HOLD_STRENGTH
