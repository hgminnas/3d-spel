extends Node3D

var times_entered_start = 0

var total_time := 900
var time_left := 900

@onready var timer_text = $TimersNAudio/TimerText
@onready var timer = $TimersNAudio/ToLarsArrive2 # 900 sek


func _on_start_area_body_entered(body) -> void:
	if body.is_in_group("player") and times_entered_start < 1:
		times_entered_start += 1
		$TimersNAudio/ToLarsArrive1.start()

func _on_to_lars_arrive_1_timeout() -> void:
	$TimersNAudio/LarsArrive1.play()


func _on_lars_arrive_1_finished() -> void:
	$TimersNAudio/ToLarsArrive2.start() # 15 min
	start_countdown() # Startar visuell timer


func _on_to_lars_arrive_2_timeout() -> void:      # Timeout => Tiden har gått ut
	$TimersNAudio/LarsArrive2.play()
	
	time_left -= 1

	if time_left <= 0:
		time_left = 0
		timer.stop()

	update_ui()

func start_countdown():
	time_left = total_time
	update_ui()


func update_ui():

	var minutes = time_left / 60
	var seconds = time_left % 60

	timer_text.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)


func _on_lars_arrive_2_finished() -> void: # När Lars har använt kortet
	get_tree().change_scene_to_file("res://Lobby/DeadScreen/dead_screen.tscn")
