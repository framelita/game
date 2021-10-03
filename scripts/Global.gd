extends Node

signal inact_shape
signal add_points
signal update_stage
signal restart_game
signal start_game
signal pause_game
signal clear_stage
signal game_over
signal next_crying_block
signal play_rotate_sound
signal play_wee_sound
signal play_thud_sound

var inactive = [] # this refers to blocks that has already touch the ground. consist of position x y
var inactive_blocks = [] # consist of the block function
var counting_down = [] # this refers to blocks that is counting down. consist of position x y
var counting_down_blocks = [] # consist of the block function
var has_cried = [] # this refers to blocks that has already cried. consist of position x y
var has_cried_blocks = [] # consist of the block function
var countdown_indexes = { # which countdown is holding which block
	"1": {},
	"2": {},
	"3": {},
	"4": {},
	"5": {}
}

var points = 0
var speed = 1 # in seconds
var grid = 32
var max_x = 320 - grid
var max_y = 640 - grid
var paused = false

var stage_dictionary = { # change this to set the stage variables
	1: {
		"max_crying": 5, # number of countdown
		"delay": 10, # seconds of each countdown
		"reaction_time": 6, # how long from cry to diw
		"target_score": 500 # target score to complete the level
	},
	2: {
		"max_crying": 5,
		"delay": 10,
		"reaction_time": 6,
		"target_score": 600
	},
	3: {
		"max_crying": 6,
		"delay": 10,
		"reaction_time": 6,
		"target_score": 700
	},
	4: {
		"max_crying": 6,
		"delay": 10,
		"reaction_time": 5,
		"target_score": 800
	},
	5: {
		"max_crying": 7,
		"delay": 10,
		"reaction_time": 5,
		"target_score": 900
	},
	6: {
		"max_crying": 7,
		"delay": 10,
		"reaction_time": 5,
		"target_score": 1000
	},
	7: {
		"max_crying": 8,
		"delay": 10,
		"reaction_time": 4,
		"target_score": 1100
	},
	8: {
		"max_crying": 8,
		"delay": 10,
		"reaction_time": 4,
		"target_score": 1200
	},
	9: {
		"max_crying": 9,
		"delay": 10,
		"reaction_time": 4,
		"target_score": 1300
	},
	10: {
		"max_crying": 9,
		"delay": 10,
		"reaction_time": 3,
		"target_score": 1000000000000000
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
var delay_between_countdown = 1

func inactivate_shape():
	emit_signal("inact_shape")

func add_points():
	points += 100
	if points%100 == 0 and speed > .3:
		speed -= .1
	if points >= target_score:
		clear_stage()
	emit_signal("add_points")

func clear_all_blocks():
	for item in inactive_blocks:
		item.destroy_block()
	inactive.clear()
	inactive_blocks.clear()
	counting_down.clear()
	counting_down_blocks.clear()
	has_cried.clear()
	has_cried_blocks.clear()
	countdown_indexes = { # which countdown is holding which block
		"1": {},
		"2": {},
		"3": {},
		"4": {},
		"5": {}
	}
	
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
		
func game_over():
	emit_signal("game_over")
	
func start_game():
	emit_signal("start_game")
	
func restart_game():
	speed = 1
	points = 0
	update_stage(0)
	get_tree().reload_current_scene()
	emit_signal("restart_game")
	
func clear_stage():
	emit_signal("clear_stage")
	
func pause_game():
	emit_signal("pause_game")
	
func next_crying_block(new_position):
	emit_signal("next_crying_block", new_position)
