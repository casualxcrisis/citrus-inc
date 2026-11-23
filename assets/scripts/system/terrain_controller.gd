extends Node2D
class_name TerrainController2D

@export var terrain_scenes: Array[PackedScene] = []
@export var terrain_velocity: float =  -300.0
@export_range(2, 100,1) var num_terrain_blocks: int = 8
@export var cull_y: float = 720.0



var terrain_belt: Array[TerrainSection2D] = []

func _ready() -> void:
	if terrain_scenes.is_empty():
		push_error("No terrain scenes assigned!")
		set_physics_process(false)
		return
	_init_blocks(num_terrain_blocks)


func _physics_process(delta: float) -> void:
	_progress_terrain(delta)
	#print(%SpeedUpTimer.time_left)
	#print(terrain_velocity)
	print(Global.buddha_bool)

func _init_blocks(number_of_blocks: int) -> void:
	for i in range(number_of_blocks):
		_append_random_block()
		
func _progress_terrain(delta: float) -> void:
	for block in terrain_belt:
		block.position.y -= terrain_velocity * delta
	
	while not terrain_belt.is_empty():
		var first_block = terrain_belt[0]
		
		if first_block.position.y <= cull_y:
			break
		
		terrain_belt.pop_front()
		_append_random_block()
		first_block.queue_free()

func _append_random_block() -> void:
	var block := terrain_scenes.pick_random().instantiate() as TerrainSection2D
	
	if block == null:
		push_error("Terrain scene must use TerrainSection2D!")
		return
	
	if terrain_belt.is_empty():
		block.position = Vector2(
			0.0,
			cull_y - block.section_height
		)
	else:
		var last_block = terrain_belt.back()
		_append_to_top_edge(last_block, block)
	
	add_child(block)
	terrain_belt.append(block)
	
func _append_to_top_edge(
	target_block: TerrainSection2D,
	appending_block: TerrainSection2D
) -> void:
	appending_block.position.x = target_block.position.x
	appending_block.position.y = (
		target_block.position.y - appending_block.section_height
	)

func _on_speed_up_timer_timeout() -> void:
	var tween = create_tween().bind_node(self)
	var current_terrain_vel = terrain_velocity
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "terrain_velocity", (current_terrain_vel - 50), 3.0) #duration and speed up amount can be tweaked to levels that make sense here
	%SpeedUpTimer.start(10) #should add different timer amounts for different speed levels i.e. one time for easy and middle speeds and longer timer for the last harder ones <800 is impossible tho
