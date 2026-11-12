extends CharacterBody2D

@onready var anim_player = $AnimatedSprite2D

var last_mouse_angle = 0.0

func  _physics_process(delta: float) -> void:	
	var vel : Vector2 = (get_global_mouse_position() - global_position)
	if vel.length() > 900:
		vel = vel.normalized() * Global.base_speed
	velocity = vel * Global.base_accel
	velocity.y = Global.base_fwd_vel
	move_and_slide()
	
	## animation stuff
	var current_mouse_angle = vel.angle()
	
	if rad_to_deg(current_mouse_angle) > 90 or rad_to_deg(current_mouse_angle) < -90:
		anim_player.flip_h = true
	else:
		anim_player.flip_h = false
		
	if abs(vel).x > 50:
		if anim_player.animation != "turn" and anim_player.animation != "turn-idle":
			anim_player.play("turn")
	else:
		if anim_player.animation != "turn-finish" and anim_player.animation != "idle":
			anim_player.play("turn-finish")
		
		## old snap to idle in case turn finish breaks 
		#anim_player.play("idle")
	
	last_mouse_angle = current_mouse_angle

## more animation stuff
func _on_animated_sprite_2d_animation_finished():
	if anim_player.animation == "turn":
		anim_player.play("turn-idle")
	if anim_player.animation == "turn-finish":
		anim_player.play("idle")
