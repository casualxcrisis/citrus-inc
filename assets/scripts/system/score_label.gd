extends RichTextLabel


func _process(delta: float) -> void:
	set_text("Juiciness: " + var_to_str(Global.fruit_score))
