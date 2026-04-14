extends Node3D


func _on_mazetrigger_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		get_node("Maze/DangerController").start_cycle()
