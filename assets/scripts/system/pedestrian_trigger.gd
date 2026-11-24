extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_ped_walk()

##Sets pedestrian walk and stops them to keep pedestrians from already walking in different level chunks
func _ped_walk():
	Global.ped_bool = true
	await get_tree().create_timer(5).timeout
	Global.ped_bool = false
