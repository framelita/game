extends Node2D

onready var shape1 = preload("res://Shape1.tscn")
onready var shape2 = preload("res://Shape2.tscn")
onready var shape3 = preload("res://Shape3.tscn")
onready var shape4 = preload("res://Shape4.tscn")
onready var shape5 = preload("res://Shape5.tscn")
onready var shape6 = preload("res://Shape6.tscn")
onready var shape7 = preload("res://Shape7.tscn")
var arrow = load("res://assets/graphics/cursor-default.png")
var heart = load("res://assets/graphics/cursor-heart.png")
var hand = load("res://assets/graphics/cursor-click.png")
var shapes = []
var active_shape
var has_active_shape = false
var rnd = RandomNumberGenerator.new()
var num:int = -1
var next_num:int = 0
var countdown_timer1 = 0
var countdown_timer2 = 0
var countdown_timer3 = 0
var countdown_timer4 = 0
var countdown_timer5 = 0
var countdown_started = false
var cd_index = 0

func _ready():
	Input.set_custom_mouse_cursor(arrow)
	Input.set_custom_mouse_cursor(heart, Input.CURSOR_POINTING_HAND)
	
	shapes = [shape1,shape2,shape3,shape4,shape5,shape6,shape7]
	rnd.randomize()
	var _error = Global.connect("play_rotate_sound", self, "play_rotate_sound")
	var _error2 = Global.connect("play_wee_sound", self, "play_wee_sound")
	var _error3 = Global.connect("play_thud_sound", self, "play_thud_sound")
	var _error4 = Global.connect("pause_game", self, "pause_game")
	var _error5 = Global.connect("start_game", self, "start_game")
	var _error6 = Global.connect("restart_game", self, "restart_game")
	var _error7 = Global.connect("game_over", self, "game_over")
	var _error8 = Global.connect("next_crying_block", self, "next_crying_block")
	var _error9 = Global.connect("clear_stage", self, "clear_stage")
	var _error10 = Global.connect("show_story", self, "show_story")
	
	$Story/Tutorial.hide()
	
	# for when user click restart
	if Global.has_played_before:
		$Story.hide()
		start_game()

# in here, Timer is used for moving the block down every sec or showing new shapes on top
func _on_Timer_timeout():
	$Timer.wait_time = Global.speed
	
	if not has_active_shape and not Global.paused:
		num = rnd.randi() % 7 if num == -1 else next_num
		next_num = rnd.randi() % 7
		$NextShapePanel/T/V/Control/Sprite.frame = next_num
		$NextShapePanel/T/V/Control.show()
		active_shape = shapes[num].instance()
		$ShapesArea.add_child(active_shape)
		active_shape.position = Vector2(4 * Global.grid, Global.grid)
		has_active_shape = true
		
		if Global.inactive.size() >= Global.blocks_to_start_countdown and not countdown_started:
			countdown_started = true
	else:
		move_down()

func add_to_cried(string_index):
	var total_inactive = Global.inactive.size()
	var selected_index = rnd.randi() % total_inactive
	
	var selected_position = Global.inactive[selected_index]
	var selected_block = Global.inactive_blocks[selected_index]
	
	# if it has cried before, select another block
	if Global.has_cried.has(selected_position):
		add_to_cried(string_index)
	else:
		selected_block.start_countdown()
		Global.counting_down.append(selected_position)
		Global.has_cried.append(selected_position)
		Global.countdown_indexes[string_index] = selected_position

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

func _input(_event):
	if active_shape and not Global.paused:
		if Input.is_action_just_pressed("ui_right"):
			move_right()
		if Input.is_action_just_pressed("ui_left"):
			move_left()
		if Input.is_action_pressed("ui_down"):
			move_down()
		if Input.is_action_just_pressed("ui_up"):
			active_shape.rotate_it()
			

func play_rotate_sound():
	$SFXRotate.play()

func play_wee_sound():
	$SFXWee.play()

func play_thud_sound():
	$SFXThud.play()

func pause_game():
	Input.set_custom_mouse_cursor(heart, Input.CURSOR_POINTING_HAND)
	print("PAISED")
	Global.paused = true
	if has_active_shape:
		active_shape.queue_free() # ensure new shape is cleared before new stage
	active_shape = null
	has_active_shape = false
	$Timer.stop()
	$CountdownTriggerTimer.stop()
	$CountdownTimer1.stop()
	$CountdownTimer2.stop()
	$CountdownTimer3.stop()
	$CountdownTimer4.stop()
	$CountdownTimer5.stop()
	$NextShapePanel/T/V/Control.hide()
	
func show_screen(screen):
	$Overlay/Opening.hide()
	$Overlay/GameOver.hide()
	$Overlay/StageClear.hide()
	$Overlay/YouWon.hide()
	
	if screen == 'Opening':
		$Overlay/CenterContainer/VBoxContainer/Label.text = ""
		$Overlay/CenterContainer/VBoxContainer/StartButton.text = 'Start Game'
	elif screen == 'StageClear':
		$Overlay/CenterContainer/VBoxContainer/Label.text = "Score: " + str(Global.points)
		$Overlay/CenterContainer/VBoxContainer/StartButton.text = 'Next Stage'
	else:
		$Overlay/CenterContainer/VBoxContainer/Label.text = "Score: " + str(Global.points)
		$Overlay/CenterContainer/VBoxContainer/StartButton.text = 'Restart Game'
	
	$Overlay.show()
	$Overlay.get_node(screen).show()
	
func hide_other_screen():
	$Overlay/Opening.hide()
	$Overlay/GameOver.hide()
	$Overlay/StageClear.hide()
	$Overlay/YouWon.hide()

func game_over():
	print("game_over")
	Global.pause_game()
	$SFXGameOver.play()
	show_screen('GameOver')	
	
func start_game():
	# Input.set_custom_mouse_cursor(hand, Input.CURSOR_POINTING_HAND)
	Global.paused = false
	cd_index = 0
	hide_other_screen()
	$Overlay.hide()
	$Timer.start()
	$CountdownTriggerTimer.start()
	has_active_shape = false
	countdown_started = false
	Global.update_stage(Global.stage + 1)
	$MaxCrying.text = "Max Crying: " + str(Global.max_crying)
	$Delay.text = "Delay: " + str(Global.delay)
	$ReactionTime.text = "ReactionTime: " + str(Global.reaction_time)
	$TargetScore.text = "TargetScore: " + str(Global.target_score)
	$Stage/Label.text = str(Global.stage)
	
func clear_stage():
	print("clear_stage")
	Global.pause_game()
	$SFXStageClear.play()
	show_screen('StageClear')

func next_crying_block(new_position):
	# print("next_crying_block", new_position)
	for index in Global.countdown_indexes:
		var block = Global.countdown_indexes[index]
		if block:
			if block == new_position:
				Global.countdown_indexes[index] = {}
				reset_countdown(index)
				start_countdown_timer(index)
	var block_index = Global.counting_down.find(new_position)
	if block_index >= 0:
		Global.counting_down.remove(block_index)

func start_countdown_timer(number):
	get_node("CountdownTimer" + str(number)).start()
	
func reset_countdown(n):
	var number = str(n)
	var random = rnd.randi_range(Global.delay - 2, Global.delay + 2)
	get_node("CountdownTimer" + number).wait_time = random


func _on_CountdownTriggerTimer_timeout():
	Global.game_time += 1
	$GeneralTimer.text = "Time: " +  str(Global.game_time)
	$CD.text = "CD: " + str(Global.counting_down.size()) + "\nHas cried:" + str(Global.has_cried.size())
	
	if countdown_started:
		cd_index += 1
		if cd_index <= 5:
			reset_countdown(cd_index)
			start_countdown_timer(cd_index)
	
func _on_CountdownTimer1_timeout():
	if Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(1)
		add_to_cried("1")
		start_countdown_timer(1)

func _on_CountdownTimer2_timeout():
	if Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(2)
		add_to_cried("2")
		start_countdown_timer(2)

func _on_CountdownTimer3_timeout():
	if Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(3)
		add_to_cried("3")
		start_countdown_timer(3)

func _on_CountdownTimer4_timeout():
	if Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(4)
		add_to_cried("4")
		start_countdown_timer(4)

func _on_CountdownTimer5_timeout():
	if Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(5)
		add_to_cried("5")
		start_countdown_timer(5)

func show_story():
	$Story.show()
