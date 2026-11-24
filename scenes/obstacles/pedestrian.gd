extends CharacterBody2D


func _process(delta: float) -> void:
	if Global.ped_bool:
		velocity.x = -250
		move_and_slide()
