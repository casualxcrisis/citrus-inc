extends CharacterBody2D

func  _physics_process(delta: float) -> void:
	var vel : Vector2 = (get_global_mouse_position() - global_position)
	if vel.length() > 900:
		vel = vel.normalized() * Global.base_speed
	velocity = vel * Global.base_accel
	velocity.y = Global.base_fwd_vel
	move_and_slide()
