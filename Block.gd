extends Node2D

var is_active = false
var timer = -1
var animation_time = 3 # for crying animation
var countdown_timer = Global.reaction_time + animation_time
var colour # colour will be set from Shape0

func _ready():
	is_active = true
	$RichTextLabel.bbcode_text = str(timer)
	var _error = Global.connect("inact_shape", self, "inactivate_it")
	var _error2 = Global.connect("pause_game", self, "pause_game")
	
func inactivate_it():
	if is_active:
		get_parent().is_fixed = true
		is_active = false
		get_tree().root.get_node("Main").has_active_shape = false
		Global.inactive.append(get_parent().position + position)
		Global.inactive_blocks.append(self)
		Global.inactivate_shape()
		Global.play_thud_sound()
		check_full_line()
		
func can_rotate(val) -> bool:
	var new_x = get_parent().position.x + val.x
	var new_y = get_parent().position.y + val.y
	
	if Global.inactive.has(Vector2(new_x, new_y)) or is_off_screen(Vector2(new_x, new_y)):
		return false
	else:
		return true
		
func is_off_screen(vec) -> bool:
	if vec.x < 0:
		return true
	elif vec.x >= get_parent().get_parent().get_rect().size.x:
		return true
	elif vec.y < 0:
		return true
	elif vec.y >= get_parent().get_parent().get_rect().size.y:
		return true
	else:
		return false

func can_move_down():
	var new_x = get_parent().position.x + position.x
	var new_y = get_parent().position.y + position.y
	
	if Global.inactive.has(Vector2(new_x, new_y + Global.grid)) or new_y == Global.max_y:
		inactivate_it()
		return false
	else:
		return true
		
func can_move_left():
	var new_x = get_parent().position.x + position.x
	var new_y = get_parent().position.y + position.y
	
	if new_x == 0 or (Global.inactive.has(Vector2(new_x - Global.grid, new_y))) or not is_active:
		return false
	else:
		return true
		
func can_move_right():
	var new_x = get_parent().position.x + position.x
	var new_y = get_parent().position.y + position.y
	
	if new_x == Global.max_x or (Global.inactive.has(Vector2(new_x + Global.grid, new_y))) or not is_active:
		return false
	else:
		return true

func check_full_line():
	var index = 0
	var count = 0
	var positions_to_erase = []
	var blocks_to_shift = []
	var new_y = get_parent().position.y + position.y
	
	for i in Global.inactive:
		if i.y == new_y:
			positions_to_erase.append(index)
			count += 1
			
		index += 1
		
	if count == 10:
		destroy_line(positions_to_erase)
		index = 0
		
		for i in Global.inactive:
			if i.y < new_y:
				blocks_to_shift.append(index)
			index += 1
		shift_blocks(blocks_to_shift)
		
func destroy_line(indexes):
	Global.add_points()
	Global.play_wee_sound()
	stop_counting_down_animation()
	var line_vals = indexes
	
	for i in range(line_vals.size()-1,-1,-1):
		var item = Global.inactive[line_vals[i]]
		var cried_index = Global.has_cried.find(item)
		var countdown_index = Global.counting_down.find(item)
		
		Global.next_crying_block(item)
		Global.inactive.remove(line_vals[i])
		Global.inactive_blocks[line_vals[i]].destroy_block()
		Global.inactive_blocks.remove(line_vals[i])
		if cried_index >= 0:
			Global.has_cried.remove(cried_index)
		if countdown_index >= 0:
			Global.counting_down.remove(countdown_index)
		
func shift_blocks(blocks):
	for i in blocks:
		# when shifting down, check whether it exist in has_cried and counting_down
		var cried_index = Global.has_cried.find(Global.inactive[i])
		var countdown_index = Global.counting_down.find(Global.inactive[i])
		
		Global.inactive[i].y += Global.grid
		Global.inactive_blocks[i].position.y += Global.grid
		
		var new_position = Global.inactive[i]
		if cried_index >= 0:
			Global.has_cried[cried_index].y = Global.inactive[i].y
		if countdown_index >= 0:
			Global.counting_down[countdown_index].y = Global.inactive[i].y
	
func destroy_block():
	queue_free()

func dying_block():
	$Timer.stop()
	$Sprite.frame = 4
	var new_x = get_parent().position.x + position.x
	var new_y = get_parent().position.y + position.y
	var vector = Vector2(new_x, new_y)
	
	var index = Global.inactive.find(vector)
	var cried_index = Global.has_cried.find(vector)
	var countdown_index = Global.counting_down.find(vector)
	print("index", index, " cried:", cried_index, " cd: ", countdown_index)
		
	if index >= 0:
		Global.inactive.remove(index)
		Global.inactive_blocks[index].destroy_block()
		Global.inactive_blocks.remove(index)
		
	if cried_index >= 0:
		Global.has_cried.remove(cried_index)
		
	if countdown_index >= 0:
		Global.next_crying_block(vector)
		Global.counting_down.remove(countdown_index)
		
		
func start_countdown():
	timer = countdown_timer
	$Timer.start()
	
func stop_counting_down_animation():
	$SlimeBody.play(colour)
	$SlimeFace.play()
	$SFXTick.stop()
	
func reset_timer():
	timer += countdown_timer
	stop_counting_down_animation()
	$Timer.start()

func hide_all_sprites():
	$TextureButton.hide()
	$SlimeBody.hide()
	$SlimeFace.hide()
	$Sprite.hide()

func _on_Timer_timeout():
	timer -= 1
	$RichTextLabel.bbcode_text = str(timer)
	
	if timer == countdown_timer - 1:
		# start the blinking
		$SlimeBody.play(colour + '-blink')
		$SlimeFace.play('angry')
		$SFXTick.play()
		
	if timer <= animation_time:
		# don't allow user to click anymore
		$SlimeBody.play('cry')
		$SlimeFace.play('cry')
		$TextureButton.disabled = true
		
	if timer == 1:
		# start show the flying away
		$ParticlesSad.restart()
		$SFXSad.play()
		hide_all_sprites()
		$SFXTick.stop()
		
	if timer <= 0:
		#actually clear the block
		dying_block()
		

func _on_TextureButton_pressed():
	# only show event when the timer is between 0 and the coutndown timer
	if timer > 0 and timer <= countdown_timer:
		$ParticlesHeart.restart()
		$Timer.stop()
		var new_position = get_parent().position + position
		Global.next_crying_block(new_position)
		stop_counting_down_animation()
		timer = -1
		$RichTextLabel.bbcode_text = str(timer)
	elif timer == 0:
		$TextureButton.disabled = true

func _on_TextureButton_button_down():
	if timer > 0 and timer <= countdown_timer:
		$SFXGiggle.play()
		$SlimeBody.play(colour + '-click')
		$SlimeFace.play('giggle')
		Global.block_pressed()

func _on_TextureButton_button_up():
	Global.block_released()
	if timer > 0 and timer <= countdown_timer:
		$SlimeBody.play(colour)
		$SlimeFace.play()

func pause_game():
	$SFXTick.stop()
	$Timer.stop()

