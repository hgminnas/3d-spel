extends CharacterBody3D

signal player_hidden_status_update(is_hidden: bool)

const SPEED = 4.0
var JUMP_VELOCITY = 6.5
var ACCELERATION = 1.76
const DECELERATION = 10


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y).normalized())
	
	if direction:
		velocity.x = direction.x * SPEED * ACCELERATION
		velocity.z = direction.z * SPEED * ACCELERATION
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * DECELERATION)
		velocity.z = move_toward(velocity.z, 0, SPEED * delta * DECELERATION)
		
	move_and_slide()

func _can_not_move():
	ACCELERATION = 0
	JUMP_VELOCITY = 0


func _on_danger_controller_state_changed(new_state: Variant) -> void:
	print("Updated state", new_state)
	$Head.maze_hiding_state = new_state

func _on_head_player_hidden_status_update(is_hidden: Variant) -> void:
	emit_signal("player_hidden_status_update", is_hidden)


func _on_hallway_can_not_move(if_move: bool) -> void:
	if if_move:
		_can_not_move()
