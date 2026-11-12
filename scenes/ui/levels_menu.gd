extends Node2D

func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")

func _on_play_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/opening_comic.tscn")
