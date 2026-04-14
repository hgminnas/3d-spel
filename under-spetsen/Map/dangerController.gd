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

var player_is_hidden := false

var waiting_on_new_cycle := true

var hunts_disabled := false

# Config
@export var min_delay = 8.0
@export var max_delay = 40.0
@export var min_duration = 10.0 # must be a number greater than 6.0
@export var max_duration = 18.0

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
var current_hunt = false

# Hunt voices
@onready var Voices = $Voices
var voices = [
	preload("res://Voice/Cajsa/Debatt.mp3"),
	preload("res://Voice/Cajsa/Sherlock.mp3"),
	preload("res://Voice/Cajsa/Skillnaden på.mp3"),
	preload("res://Voice/Sofie/Minna_1.mp3"),
	preload("res://Voice/Sofie/Minna_2.mp3"),
	preload("res://Voice/Sofie/Minna_3.mp3"),
	preload("res://Voice/Sofie/Minna_4.mp3"),
	preload("res://Voice/Ahmad/Idrottslärare.mp3"),
	preload("res://Voice/Ahmad/Kaffe.mp3"),
	preload("res://Voice/Ahmad/Robot.mp3")
	
	
]

func _ready():
	randomize()

# --- Hunt cycle --- 


# ------- Pauses Between Hunts --------
func start_cycle():
	if hunts_disabled:
		return
		
	var delay = randf_range(min_delay, max_delay)
	#print("Start_cycle started")
	await get_tree().create_timer(delay).timeout # Pause between hunts
	#print("Timeout")
	
	if hunts_disabled:
		return
		
	start_hunt()

# ----------- Hunt Started ------------
func start_hunt():
	$HeartBeat.volume_db = -80
	$FootSteps.volume_db = -80
	Voices.volume_db = -80

	#print("Hunt mode started")
	hunt_duration = randf_range(min_duration, max_duration)
	hunt_time = 0.0
	
	$HeartBeat.play()
	$FootSteps.play()
	$ToVoices.start()
	current_hunt = true

	self.state = State.ACTIVE
	emit_signal("hunt_started", hunt_duration)

# --------- Voice randomizer ---------
func _on_to_voices_timeout() -> void:
	play_random_sound()
	
func play_random_sound():
	if Voices.playing:
		return
		
	Voices.stream = voices.pick_random()
	Voices.play()

#-------- Exit Hunt -----------
#func start_exit_hunt():
	#print("start_exit_hunt")
	#self.state = State.ACTIVE
	#emit_signal("hunt_started", "8")
	#$HeartBeat.play()
	#$ExitHuntTimer.start()
#
#func _on_exit_hunt_timer_timeout() -> void:
	#end_hunt()
## ---------------------------------

# ----------- End Hunt -------------
func end_hunt():
	self.state = State.IDLE
	emit_signal("hunt_ended")
	
	await get_tree().create_timer(0.5).timeout
	$HeartBeat.stop()
	$FootSteps.stop()
	Voices.stop()
	current_hunt = false
	#print("hunt ended")

	if player_is_hidden:
		print("alive")
		if waiting_on_new_cycle:
			start_cycle()
	else:
		print("dead")
		get_tree().change_scene_to_file("res://Lobby/DeadScreen/dead_screen.tscn")



# --- Process loop ---
func _process(delta):
	if hunts_disabled:
		return
	
	if state != State.ACTIVE:
		return

	hunt_time += delta
	var progress = clamp(hunt_time / hunt_duration, 0.0, 1.0)
	
	## voices start after 6s
	#var voice_progress = 0
	#if hunt_time > 6:
		#voice_progress = (hunt_time - 6) / (hunt_duration - 6)
		
	emit_signal("hunt_progress", progress)
	
	#$HeartBeat.volume_db = lerp(5, 10, progress)
	#$FootSteps.volume_db = lerp(5, 7, progress)
	#var VOICES_LERP_HIGH = 20
	#var VOICES_LERP_LOW = -5
	#if voice_progress < 0.5: 
		#Voices.volume_db = lerp(VOICES_LERP_LOW, VOICES_LERP_HIGH, voice_progress)
	#else: 
		#Voices.volume_db = lerp(VOICES_LERP_HIGH, VOICES_LERP_LOW, voice_progress)
	# --- "passerar förbi"-kurva ---
	
	var curve = sin(progress * PI)

	# Footsteps + Heartbeat
	var min_db = -40
	var max_db = -10
	var volume = lerp(min_db, max_db, curve)

	$HeartBeat.volume_db = volume
	$FootSteps.volume_db = volume


	# --- Voices (startar efter 6 sek) ---
	if hunt_time > 6:
		var voice_progress = (hunt_time - 6) / (hunt_duration - 6)
		voice_progress = clamp(voice_progress, 0.0, 1.0)

		var voice_curve = sin(voice_progress * PI)
		Voices.volume_db = lerp(-35, -10, voice_curve)

	if progress >= 1.0:
		end_hunt()
	


# ------------ Restart or not depending on if player i hiding --------
func _on_player_player_hidden_status_update(is_hidden: bool) -> void:
	player_is_hidden = is_hidden
	
	if player_is_hidden:
		waiting_on_new_cycle = false
		return

	if not waiting_on_new_cycle:
		waiting_on_new_cycle = true
		start_cycle()

## ----------------- Starts the exit hunt -----------------------
#func _on_exit_trigger_area_body_entered(body: Node3D) -> void:
	#if body.is_in_group("player") and waiting_on_new_cycle and not current_hunt:
		#start_exit_hunt()

# ---------------- Stop this whole hunt-level ---------------
func _on_exit_stop_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		hunts_disabled = true
		current_hunt = false
		$HeartBeat.stop()
		$FootSteps.stop()
		self.state = State.IDLE
		print("hunts permanently stopped")
		
