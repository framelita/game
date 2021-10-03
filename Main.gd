extends Node2D

onready var shape1 = preload("res://Shape1.tscn")
onready var shape2 = preload("res://Shape2.tscn")
onready var shape3 = preload("res://Shape3.tscn")
onready var shape4 = preload("res://Shape4.tscn")
onready var shape5 = preload("res://Shape5.tscn")
onready var shape6 = preload("res://Shape6.tscn")
onready var shape7 = preload("res://Shape7.tscn")
var shapes = []
var active_shape
var active_block = false
var rnd = RandomNumberGenerator.new()
var num:int = -1
var next_num:int = 0

func _ready():
	shapes = [shape1,shape2,shape3,shape4,shape5,shape6,shape7]
	rnd.randomize()
	Global.connect("play_rotate_sound", self, "play_rotate_sound")
	Global.connect("play_wee_sound", self, "play_wee_sound")
	Global.connect("play_thud_sound", self, "play_thud_sound")

# in here, Timer is used for moving the block down every sec or showing new shapes on top
func _on_Timer_timeout():
	$Timer.wait_time = Global.speed
	if not active_block:
		num = rnd.randi() % 7 if num == -1 else next_num
		next_num = rnd.randi() % 7
		$NextShapePanel/V/Control/Sprite.frame = next_num
		active_shape = shapes[num].instance()
		$ShapesArea.add_child(active_shape)
		active_shape.position = Vector2(4 * Global.grid, Global.grid)
		active_block = true
	else:
		move_down()

func _on_StartButton_pressed():
	Global.update_stage(1)
	$Timer.start()

func move_left():
	if active_block:
		active_shape.move_left()

func move_right():
	if active_block:
		active_shape.move_right()

func move_down():
	if active_block:
		active_shape.move_down()
		$Timer.start()

func _input(event):
	if active_shape:
		if Input.is_action_just_pressed("ui_right"):
			move_right()
		if Input.is_action_just_pressed("ui_left"):
			move_left()
		if Input.is_action_just_pressed("ui_down"):
			move_down()
		if Input.is_action_just_pressed("ui_up"):
			active_shape.rotate_it()

func play_rotate_sound():
	$SFXRotate.play()

func play_wee_sound():
	$SFXWee.play()

func play_thud_sound():
	$SFXThud.play()
