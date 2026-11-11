extends Node2D

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://scenes/environment/testing_ground.tscn")
