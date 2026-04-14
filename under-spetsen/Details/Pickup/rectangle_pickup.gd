extends RigidBody3D

@onready var drop_sound = $DropSound

var min_impact_velocity := 0.5
var can_play_sound := true
var last_velocity := Vector3.ZERO

func _ready():
	contact_monitor = true
	max_contacts_reported = 5
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	last_velocity = linear_velocity

func _on_body_entered(body) -> void:
	if not can_play_sound:
		return
	
	var impact_speed = last_velocity.length()
	
	if impact_speed > min_impact_velocity and drop_sound:
		drop_sound.volume_db = clamp(impact_speed * 2.0, -20, 10)
		drop_sound.play()
		
		can_play_sound = false
		await get_tree().create_timer(0.2).timeout
		can_play_sound = true
