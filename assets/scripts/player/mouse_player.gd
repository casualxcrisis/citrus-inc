extends CharacterBody2D

@onready var anim_player = $AnimatedSprite2D
@onready var particles = $Piviot/CPUParticles2D
@onready var particle_piviot = $Piviot

var last_mouse_angle = 0.0

var facing_right = true
var is_turning: bool = false
var active_tween : Tween

func  _physics_process(delta: float) -> void:
	var vel : Vector2 = (get_global_mouse_position() - global_position)
	if vel.length() > 900:
		vel = vel.normalized() * Global.base_speed
	velocity = vel * Global.base_accel
	velocity.y = 0
	if Global.car_bool:
		Global.base_accel = 0.0
		Global.base_speed = 0
	if Global.buddha_bool:
		_buddha_buffer()
	if Global.mult_bool:
		_mult_buffer()
	move_and_slide()
	print(Global.mult_bool)
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
		
		if not is_turning:
			is_turning = true
			if active_tween:
				active_tween.kill()
			active_tween = create_tween()
			
			
			active_tween.tween_property(
				particle_piviot, 
				"global_rotation_degrees", 
				sign(vel.x) * 20.0, 0.4)
			
	else:
		if anim_player.animation != "turn-finish" and anim_player.animation != "idle":
			anim_player.play("turn-finish")
			
		if is_turning:
			is_turning = false
			if active_tween:
				active_tween.kill()
			active_tween = create_tween()
			
			var start_angle: float = particle_piviot.global_rotation
			active_tween.tween_method(
				func(weight: float):
					particle_piviot.global_rotation = lerp_angle(
						start_angle, 0.0, weight)
						,0.0, 1.0, 0.3)
	
	last_mouse_angle = current_mouse_angle

## more animation stuff
func _on_animated_sprite_2d_animation_finished():
	## player is currently turning
	if anim_player.animation == "turn":
		anim_player.play("turn-idle")
	
	## player is not turning
	if anim_player.animation == "turn-finish":
		anim_player.play("idle")


##Sets a timeout for how long the buddha buff is active
func _buddha_buffer():
	await get_tree().create_timer(10).timeout
	Global.buddha_bool = false 
##Sets timeout for how long the score multiplier is active
func _mult_buffer():
	await get_tree().create_timer(10).timeout
	Global.mult_bool = false
##Camera shaker for the pothole
func _shaker_pot():
	Global.pothole_shake = true
	await get_tree().create_timer(0.0009).timeout #ridiculous but it works
	Global.pothole_shake = false
##Camera shaker for static obstacles that aren't the car
func _shaker_static():
	Global.obst_shake = true
	await get_tree().create_timer(0.0009).timeout
	Global.obst_shake = false
##Camera shaker for pedestrians
func _ped_shaker():
	Global.ped_shake = true
	await get_tree().create_timer(0.0009).timeout
	Global.ped_shake = false
##Camer shaker for cars
func _car_shaker():
	Global.car_shake = true
	await get_tree().create_timer(0.0009).timeout
	Global.car_shake = false

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("pothole"):
		%PotholeHit.play()
		_shaker_pot()
	
func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		_car_shaker()
		Global.car_bool = true
		%CarCrash.play()
	elif body.is_in_group("static_obstacle"):
		%Blood.emitting = true
		%ObstacleHit.play()
		_shaker_static()
		Global.fruit_score -= Global.obst_score_loss
	elif body.is_in_group("pedestrian"):
		%Blood.emitting = true
		%PedHit.play()
		_ped_shaker()
		Global.fruit_score -= Global.ped_score_loss
	

func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("lime"):
		%LimePickup.play()
		if Global.buddha_bool:
			Global.fruit_score += (Global.lime * 2)
		elif Global.mult_bool:
			Global.fruit_score += (Global.lime * 5)
		else: 
			Global.fruit_score += Global.lime
		body.queue_free()
	elif body.is_in_group("lemon"):
		%LemonPickup.play()
		if Global.buddha_bool:
			Global.fruit_score += (Global.lemon * 2)
		elif Global.mult_bool:
			Global.fruit_score += (Global.lemon * 5)
		else:
			Global.fruit_score += Global.lemon
		body.queue_free()
	elif body.is_in_group("orange"):
		%OrangePickup.play()
		if Global.buddha_bool:
			Global.fruit_score += (Global.orange * 2)
		elif Global.mult_bool:
			Global.fruit_score += (Global.orange * 5)
		else:
			Global.fruit_score += Global.orange
		body.queue_free()
	elif body.is_in_group("buddha"):
		%BuddhaPickup.play()
		Global.fruit_score += Global.buddha
		Global.buddha_bool = true
		body.queue_free()
		print(Global.buddha_bool)
	elif body.is_in_group("score_mult"):
		Global.mult_bool = true
		body.queue_free()
