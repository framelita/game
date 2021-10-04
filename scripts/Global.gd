extends Node

signal inact_shape
signal add_points
signal update_stage
signal restart_game
signal start_game
signal pause_game
signal clear_stage
signal game_over
signal show_story
signal next_crying_block
signal play_rotate_sound
signal play_wee_sound
signal play_thud_sound
signal block_pressed
signal block_released

var inactive = [] # this refers to blocks that has already touch the ground. consist of position x y
var inactive_blocks = [] # consist of the block function
var counting_down = [] # this refers to blocks that is counting down. consist of position x y
var has_cried = [] # this refers to blocks that has already cried. consist of position x y
var countdown_indexes = { # which countdown is holding which block
	"1": {},
	"2": {},
	"3": {},
	"4": {},
	"5": {}
}

var game_time = 0
var points = 0
var speed = 1 # in seconds
var grid = 32
var max_x = 320 - grid
var max_y = 640 - grid
var paused = false
var game_over = false
var has_played_before = false
var has_started_game = false
var has_seen_tutorial = false

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
		"target_score": 1100
	},
	3: {
		"max_crying": 6,
		"delay": 10,
		"reaction_time": 6,
		"target_score": 1800
	},
	4: {
		"max_crying": 6,
		"delay": 10,
		"reaction_time": 5,
		"target_score": 2600
	},
	5: {
		"max_crying": 7,
		"delay": 10,
		"reaction_time": 5,
		"target_score": 3500
	},
	6: {
		"max_crying": 7,
		"delay": 10,
		"reaction_time": 5,
		"target_score": 4500
	},
	7: {
		"max_crying": 8,
		"delay": 10,
		"reaction_time": 4,
		"target_score": 5600
	},
	8: {
		"max_crying": 8,
		"delay": 10,
		"reaction_time": 4,
		"target_score": 6800
	},
	9: {
		"max_crying": 9,
		"delay": 10,
		"reaction_time": 4,
		"target_score": 8100
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
		if is_instance_valid(item):
			item.destroy_block()
	inactive.clear()
	inactive_blocks.clear()
	counting_down.clear()
	has_cried.clear()
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
	game_over = true
	emit_signal("game_over")
	
func start_game():
	emit_signal("start_game")
	
func restart_game():
	has_played_before = true
	stage = 0
	game_time = 0
	speed = 1
	points = 0
	game_over = false
	print("stage is", stage, " - ", game_time, " - ", points)
	get_tree().reload_current_scene()
	
func clear_stage():
	emit_signal("clear_stage")
	
func pause_game():
	emit_signal("pause_game")
	
func next_crying_block(new_position):
	emit_signal("next_crying_block", new_position)
	
func block_pressed():
	emit_signal("block_pressed")
	
func block_released():
	emit_signal("block_released")

func show_story():
	emit_signal("show_story")
