extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	await get_tree().create_timer(4).timeout
	Global.terrain_speed = -900

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("free_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
