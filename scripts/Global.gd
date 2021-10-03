extends Node

signal inact_shape
signal add_points
signal update_stage
signal play_rotate_sound
signal play_wee_sound
signal play_thud_sound

var inactive = []
var inactive_blocks = []
var points = 0
var speed = 1
var grid = 32
var max_x = 320 - grid
var max_y = 640 - grid

var stage_dictionary = {
	1: {
		"max_crying": 5, # number of countdown
		"delay": 10, # seconds of each countdown
		"reaction_time": 10, # how long from cry to diw
		"target_rows": 5 # how many rows to clear
	},
	2: {
		"max_crying": 5,
		"delay": 10,
		"reaction_time": 10,
		"target_rows": 10
	},
}

var stage = 0
var max_crying = 5 # number of countdown
var delay = 10 # seconds of each countdown
var reaction_time = 10 # how long from cry to diw
var target_rows = 5 # how many rows to clear

func inactivate_shape():
	emit_signal("inact_shape")

func add_points():
	points += 100
	if points%100 == 0 and speed > .3:
		speed -= .1
	emit_signal("add_points")
	
func update_stage(new_stage):
	stage = new_stage
	emit_signal("update_stage")
	
func play_rotate_sound():
	emit_signal("play_rotate_sound")
	
func play_wee_sound():
	emit_signal("play_wee_sound")
	
func play_thud_sound():
	emit_signal("play_thud_sound")
	
func update_stage_variables():
	max_crying = stage_dictionary[stage]["max_crying"]
	delay = stage_dictionary[stage]["delay"]
	reaction_time = stage_dictionary[stage]["reaction_time"]
	target_rows = stage_dictionary[stage]["target_rows"]
	
func restart_game():
	speed = 1
	points = 0
	inactive.clear()
	inactive_blocks.clear()
	update_stage(1)
	update_stage_variables()
	get_tree().reload_current_scene()
