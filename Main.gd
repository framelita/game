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
var countdown_timer1 = 0
var countdown_timer2 = 0
var countdown_timer3 = 0
var countdown_timer4 = 0
var countdown_timer5 = 0
var countdown_started = false

func _ready():
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

# in here, Timer is used for moving the block down every sec or showing new shapes on top
func _on_Timer_timeout():
	$Timer.wait_time = Global.speed
	
	if not has_active_shape and not Global.paused:
		num = rnd.randi() % 7 if num == -1 else next_num
		next_num = rnd.randi() % 7
		$NextShapePanel/V/Control/Sprite.frame = next_num
		active_shape = shapes[num].instance()
		$ShapesArea.add_child(active_shape)
		active_shape.position = Vector2(4 * Global.grid, Global.grid)
		has_active_shape = true
		
		if Global.inactive.size() >= Global.blocks_to_start_countdown and not countdown_started:
			countdown_started = true
	else:
		move_down()

func add_to_cried(string_index):
	print("add to cried", string_index)
	var total_inactive = Global.inactive.size()
	var selected_index = rnd.randi() % total_inactive
	
	var selected_position = Global.inactive[selected_index]
	var selected_block = Global.inactive_blocks[selected_index]
	
	# if it has cried before, select another block
	if Global.has_cried.has(selected_position):
		add_to_cried(string_index)
	else:
		selected_block.start_countdown()
		Global.has_cried.append(selected_position)
		Global.has_cried_blocks.append(selected_block)
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
	print("PAISED")
	Global.paused = true
	active_shape = null
	has_active_shape = false
	$Timer.stop()
	$CountdownTriggerTimer.stop()
	$CountdownTimer1.stop()
	$CountdownTimer2.stop()
	$CountdownTimer3.stop()
	$CountdownTimer4.stop()
	$CountdownTimer5.stop()
	
func show_screen(screen):
	$Overlay/Opening.hide()
	$Overlay/GameOver.hide()
	$Overlay/StageClear.hide()
	$Overlay/YouWon.hide()
	
	if screen == 'Opening':
		$Overlay/MarginContainer/StartButton.text = 'START'
	elif screen == 'StageClear':
		$Overlay/MarginContainer/StartButton.text = 'NEXT STAGE'
	else:
		$Overlay/MarginContainer/StartButton.text = 'RESTART'
	
	$Overlay.show()
	$Overlay.get_node(screen).show()
	$Overlay/MarginContainer.show()
	
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
	Global.paused = false
	hide_other_screen()
	$Overlay.hide()
	$Timer.start()
	$CountdownTriggerTimer.start()
	has_active_shape = false
	countdown_started = false
	Global.update_stage(Global.stage + 1)
	
func clear_stage():
	print("clear_stage")
	Global.pause_game()
	$SFXStageClear.play()
	show_screen('StageClear')

func next_crying_block(new_position):
	for index in Global.countdown_indexes:
		var block = Global.countdown_indexes[index]
		if block:
			if block == new_position:
				Global.countdown_indexes[index] = {}
				reset_countdown(index)
				start_countdown_timer(index)

func start_countdown_timer(number):
	get_node("CountdownTimer" + str(number)).start()
	
func reset_countdown(n):
	var number = str(n)
	if number == "1":
		countdown_timer1 = Global.delay
	if number == "2":
		countdown_timer2 = Global.delay
	if number == "3":
		countdown_timer3 = Global.delay
	if number == "4":
		countdown_timer4 = Global.delay
	if number == "5":
		countdown_timer5 = Global.delay
	
var cd_index = 0

func _on_CountdownTriggerTimer_timeout():
	if countdown_started:
		cd_index += 1
		if cd_index > 5:
			$CountdownTriggerTimer.stop()
		else:
			start_countdown_timer(cd_index)
	
func _on_CountdownTimer1_timeout():
	countdown_timer1 -= 1
	$Label1.text = str(countdown_timer1)
	if countdown_timer1 <= 0 and Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(1)
		add_to_cried("1")
		start_countdown_timer(1)

func _on_CountdownTimer2_timeout():
	countdown_timer2 -= 1
	$Label2.text = str(countdown_timer2)
	if countdown_timer2 <= 0 and Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(2)
		add_to_cried("2")
		start_countdown_timer(2)

func _on_CountdownTimer3_timeout():
	countdown_timer3 -= 1
	$Label3.text = str(countdown_timer3)
	if countdown_timer3 <= 0 and Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(3)
		add_to_cried("3")
		start_countdown_timer(3)

func _on_CountdownTimer4_timeout():
	countdown_timer4 -= 1
	$Label4.text = str(countdown_timer4)
	if countdown_timer4 <= 0 and Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(4)
		add_to_cried("4")
		start_countdown_timer(4)

func _on_CountdownTimer5_timeout():
	countdown_timer5 -= 1
	$Label5.text = str(countdown_timer5)
	if countdown_timer5 <= 0 and Global.counting_down.size() <= Global.max_crying:
		# if the timer reach 0 and it's still less than max crying of the level, add more
		reset_countdown(5)
		add_to_cried("5")
		start_countdown_timer(5)


