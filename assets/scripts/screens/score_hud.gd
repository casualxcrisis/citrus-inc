extends Node2D

var elapsed := 0.0

func _process(delta):
	elapsed += delta
	if elapsed >= 1.0:  # every 1 second
		elapsed = 0.0
		$time_bar.value += 1
		$score_bar.value += 1
