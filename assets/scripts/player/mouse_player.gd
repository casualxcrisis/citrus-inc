extends CharacterBody2D

@export_category("MOVEMENT")
@export var speed = 95
@export var accel = 3.0


func  _physics_process(delta: float) -> void:
	var vel : Vector2 = (get_global_mouse_position() - global_position)
	if vel.length() > 300:
		vel = vel.normalized() * speed
	velocity = vel * accel
	move_and_slide()
