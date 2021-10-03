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
var has_active_shape = false
var rnd = RandomNumberGenerator.new()
var num:int = -1
var next_num:int = 0
var countdown_timer = 1
var countdown_started = false
var hold_down_timer = 0
var hold_down = false

func _ready():
	shapes = [shape1,shape2,shape3,shape4,shape5,shape6,shape7]
	rnd.randomize()
	Global.connect("play_rotate_sound", self, "play_rotate_sound")
	Global.connect("play_wee_sound", self, "play_wee_sound")
	Global.connect("play_thud_sound", self, "play_thud_sound")

# in here, Timer is used for moving the block down every sec or showing new shapes on top
func _on_Timer_timeout():
	$Timer.wait_time = Global.speed
	
	if not has_active_shape:
		num = rnd.randi() % 7 if num == -1 else next_num
		next_num = rnd.randi() % 7
		$NextShapePanel/V/Control/Sprite.frame = next_num
		active_shape = shapes[num].instance()
		$ShapesArea.add_child(active_shape)
		active_shape.position = Vector2(4 * Global.grid, Global.grid)
		has_active_shape = true
		print("inac", Global.inactive.size(), Global.blocks_to_start_countdown)
		if Global.inactive.size() >= Global.blocks_to_start_countdown and not countdown_started:
			start_countdown_timer()
			add_to_cried()
	else:
		move_down()

func _on_CountdownTimer_timeout():
	countdown_timer -= 1
	
	if countdown_timer <= 0 and Global.has_cried.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		add_to_cried()
		start_countdown_timer()
		
	if Global.points >= Global.target_score:
		pass
		
		
func start_countdown_timer():
	countdown_started = true
	countdown_timer = Global.delay
	$CountdownTimer.start()
	
	
func add_to_cried():
	var total_inactive = Global.inactive.size()
	var selected_index = rnd.randi() % total_inactive
	var selected_shape = Global.inactive[selected_index]
	var selected_block = Global.inactive_blocks[selected_index]
	
	selected_block.start_countdown()
	Global.has_cried.append(selected_shape)
	Global.has_cried_blocks.append(selected_block)

func _on_StartButton_pressed():
	Global.update_stage(1)
	$Timer.start()

func move_left():
	if has_active_shape:
		active_shape.move_left()

func move_right():
	if has_active_shape:
		active_shape.move_right()

func move_down():
	if has_active_shape:
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

