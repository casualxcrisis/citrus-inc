extends CharacterBody2D

func _ready() -> void:
	%FemJogger.play("run")
	%FemJogger.flip_h = true

func _process(delta: float) -> void:
	if Global.ped_bool:
		velocity.x = -380
		move_and_slide()
		
		
		


func _on_kil_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		%FemJogger.play("hit")
		Global.ped_bool = false
		await get_tree().create_timer(1.3).timeout
		self.queue_free()
		
