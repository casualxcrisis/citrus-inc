extends CharacterBody2D

#Test different speeds from 1000 - 200
@export var speed = 400.0
@export var deadzone = 5.0
#Changes movement Higher=Blocky Lower=Smooth
@export var acceleration = 2000.0

func _physics_process(delta) -> void:
	# Horizontal distance from this node to the mouse (positive = mouse is to the right)
	var distance_x = get_global_mouse_position().x - global_position.x

	# Default to standing still unless the mouse is far enough away
	var target_velocity := 0.0
	if abs(distance_x) > deadzone:
		target_velocity = sign(distance_x) * speed

	velocity.x = move_toward(velocity.x, target_velocity, acceleration * delta)

	# Up/down arrow keys move on Y Just to test forward movement
	velocity.y = Input.get_axis("forward", "backward") * speed

	move_and_slide()

#Hide Mouse
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
