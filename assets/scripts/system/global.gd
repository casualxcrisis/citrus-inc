extends Node

#Player Movement
var base_speed = 95
var base_accel = 3.0
var terrain_speed = -300.0

#camera shake
var pothole_shake = false
var obst_shake = false
var ped_shake = false
var car_shake = false

#obstacles
var car_bool = false

#Score
var fruit_score = 0
var lime = 10
var lemon = 20
var orange = 30
var buddha = 50
var buddha_bool = false
var cell_bool = false
var obst_score_loss = 10 
var ped_score_loss = 30 
var mult_bool = false

#Level Timer
var base_time = 30
var time_pickup = 5
