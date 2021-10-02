extends Node

signal inact_shape
signal add_points
signal play_rotate_sound
signal play_thud_sound

var inactive = []
var inactive_blocks = []
var points = 0
var speed = 1
var grid = 64
var max_x = 640 - grid
var max_y = 1280 - grid

func inactivate_shape():
	emit_signal("inact_shape")

func add_points():
	points += 100
	if points%100 == 0 and speed > .3:
		speed -= .1
	emit_signal("add_points")
	
func play_rotate_sound():
	print("play_rotate_sound")
	emit_signal("play_rotate_sound")
	
func play_thud_sound():
	print("play_thud_sound")
	emit_signal("play_thud_sound")
	
func restart_game():
	speed = 1
	points = 0
	inactive.clear()
	inactive_blocks.clear()
	get_tree().reload_current_scene()
