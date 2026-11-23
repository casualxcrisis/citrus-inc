extends CharacterBody2D

@onready var anim_player = $AnimatedSprite2D
@onready var particles = $CPUParticles2D

var last_mouse_angle = 0.0

var facing_right = true

func  _physics_process(delta: float) -> void:
	var vel : Vector2 = (get_global_mouse_position() - global_position)
	if vel.length() > 900:
		vel = vel.normalized() * Global.base_speed
	velocity = vel * Global.base_accel
	velocity.y = 0
	move_and_slide()
	
	## animation stuff
	var current_mouse_angle = vel.angle()
	
	if rad_to_deg(current_mouse_angle) > 90 or rad_to_deg(current_mouse_angle) < -90:
		anim_player.flip_h = true
		facing_right = false
	else:
		anim_player.flip_h = false
		facing_right = true
		
	if abs(vel).x > 50:
		if anim_player.animation != "turn" and anim_player.animation != "turn-idle":
			anim_player.play("turn")
			
			## place particle rotation logic here
	else:
		if anim_player.animation != "turn-finish" and anim_player.animation != "idle":
			anim_player.play("turn-finish")
			
			## place particle rotation logic here
	
	last_mouse_angle = current_mouse_angle

## more animation stuff
func _on_animated_sprite_2d_animation_finished():
	## player is currently turning
	if anim_player.animation == "turn":
		anim_player.play("turn-idle")
	
	## player is not turning
	if anim_player.animation == "turn-finish":
		anim_player.play("idle")

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("pothole"):
		%PotholeHit.play()
		Global.shake_switch = true
		await get_tree().create_timer(0.0009).timeout #ridiculous but it works
		Global.shake_switch = false

func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("lime"):
		if Global.buddha_bool:
			Global.fruit_score += (Global.lime * 2)
		else: 
			Global.fruit_score += Global.lime
		body.queue_free()
	elif body.is_in_group("lemon"):
		if Global.buddha_bool:
			Global.fruit_score += (Global.lemon * 2)
		else:
			Global.fruit_score += Global.lemon
		body.queue_free()
	elif body.is_in_group("orange"):
		if Global.buddha_bool:
			Global.fruit_score += (Global.orange * 2)
		else:
			Global.fruit_score += Global.orange
		body.queue_free()
	elif body.is_in_group("buddha"):
		Global.fruit_score += Global.buddha
		Global.buddha_bool = true
		body.queue_free()
		print(Global.buddha_bool)
