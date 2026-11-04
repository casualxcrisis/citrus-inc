extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("free_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
