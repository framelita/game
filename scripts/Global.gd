extends Node

signal inact_shape
signal add_points
signal update_stage
signal play_rotate_sound
signal play_wee_sound
signal play_thud_sound

var inactive = [] # this refers to blocks that has already touch the ground. consist of position x y
var inactive_blocks = [] # consist of the block function
var has_cried = [] # this refers to blocks that has already cried. consist of position x y
var has_cried_blocks = [] # consist of the block function
var points = 0
var speed = 1 # in seconds
var grid = 32
var max_x = 320 - grid
var max_y = 640 - grid

var stage_dictionary = { # change this to set the stage variables
	1: {
		"max_crying": 5, # number of countdown
		"delay": 10, # seconds of each countdown
		"reaction_time": 10, # how long from cry to diw
		"target_score": 500 # target score to complete the level
	},
	2: {
		"max_crying": 5,
		"delay": 10,
		"reaction_time": 10,
		"target_score": 1000
	},
}

var colour_dictionary = {
	1: "red",
	2: "orange",
	3: "yellow",
	4: "green",
	5: "blue",
	6: "purple",
	7: "magenta"
}

var stage = 0
var max_crying = 5 # number of countdown
var delay = 10 # seconds of each countdown
var reaction_time = 10 # how long from cry to diw
var target_score = 500 # target score to complete the level
var blocks_in_shape = 4
var shapes_to_start_countdown = 3 # change this to set how many shapes before countdown starts
var blocks_to_start_countdown = shapes_to_start_countdown * blocks_in_shape

func inactivate_shape():
	emit_signal("inact_shape")

func add_points():
	points += 100
	if points%100 == 0 and speed > .3:
		speed -= .1
	emit_signal("add_points")

func clear_all_blocks():
	inactive.clear()
	inactive_blocks.clear()
	has_cried.clear()
	has_cried_blocks.clear()
	
func update_stage(new_stage):
	stage = new_stage
	update_stage_variables()
	clear_all_blocks()
	emit_signal("update_stage")
	
func play_rotate_sound():
	emit_signal("play_rotate_sound")
	
func play_wee_sound():
	emit_signal("play_wee_sound")
	
func play_thud_sound():
	emit_signal("play_thud_sound")
	
func update_stage_variables():
	if stage >= 1:
		max_crying = stage_dictionary[stage]["max_crying"]
		delay = stage_dictionary[stage]["delay"]
		reaction_time = stage_dictionary[stage]["reaction_time"]
		target_score = stage_dictionary[stage]["target_score"]
	
func restart_game():
	speed = 1
	points = 0
	update_stage(1)
	get_tree().reload_current_scene()
