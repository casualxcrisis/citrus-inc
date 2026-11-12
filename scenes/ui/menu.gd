extends Node2D

func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/levels_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
