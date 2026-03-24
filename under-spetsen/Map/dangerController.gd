extends Node

# Signals
signal hunt_started(duration)
signal hunt_progress(progress)
signal hunt_passed      # player hid, enemy passed
signal hunt_failed      # player got caught
signal hunt_ended
signal state_changed(new_state)

# States
enum State {
	IDLE,      # cooldown between hunts
	ACTIVE,    # hunt is ongoing
	HIDING     # player is hiding
}

var player_is_hidden := true

var waiting_on_new_cycle := true

# Config
@export var min_delay = 5.0
@export var max_delay = 15.0
@export var min_duration = 6.0
@export var max_duration = 12.0

# State variable with setter to emit signal
var state : int = State.IDLE:
	set(value):
		if state == value:
			return
		state = value
		emit_signal("state_changed", state)

# Hunt tracking
var hunt_time = 0.0
var hunt_duration = 0.0

func _ready():
	start_cycle()

# --- Hunt cycle ---
func start_cycle():
	var delay = randf_range(min_delay, max_delay)
	#print("Start_cycle started")
	await get_tree().create_timer(delay).timeout
	#print("Timeout")
	start_hunt()

func start_hunt():
	#print("Hunt mode started")
	hunt_duration = randf_range(min_duration, max_duration)
	hunt_time = 0.0

	self.state = State.ACTIVE
	emit_signal("hunt_started", hunt_duration)

func end_hunt():
	self.state = State.IDLE
	emit_signal("hunt_ended")
	#print("hunt ended")

	if player_is_hidden:
		print("alive")
		if waiting_on_new_cycle:
			start_cycle()
	else:
		print("dead")


# --- Process loop ---
func _process(delta):
	if state != State.ACTIVE:
		return

	hunt_time += delta
	var progress = clamp(hunt_time / hunt_duration, 0.0, 1.0)
	emit_signal("hunt_progress", progress)

	if progress >= 1.0:
		end_hunt()



func _on_player_player_hidden_status_update(is_hidden: bool) -> void:
	player_is_hidden = is_hidden
	
	if player_is_hidden:
		waiting_on_new_cycle = false
	else:
		waiting_on_new_cycle = true
		start_cycle()
	
	# restart cycle? 
	
