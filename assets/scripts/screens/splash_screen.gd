extends Node2D

func _ready() -> void:
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://scenes/ui/opening_comic.tscn")
