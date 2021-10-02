extends Node2D

var is_active=false

func _ready():
	is_active=true
	Global.connect("inact_shape", self,"inactivate_it")
	
func inactivate_it():
	if is_active:
		get_parent().is_fixed=true
		is_active=false
		get_tree().root.get_node("Main").active_block=false
		Global.inactive.append(get_parent().position+position)
		Global.inactive_blocks.append(self)
		Global.inactivate_shape()
		check_full_line()
		
func can_rotate(val) -> bool:
	var new_x = get_parent().position.x+val.x
	var new_y = get_parent().position.y+val.y
	
	if Global.inactive.has(Vector2(new_x, new_y)) or is_off_screen(Vector2(new_x, new_y)):
		return false
	else:
		return true
		
func is_off_screen(vec) -> bool:
	print(vec.x, vec.y)
	if vec.x<0:
		return true
	elif vec.x>=get_parent().get_parent().get_rect().size.x:
		return true
	elif vec.y<0:
		return true
	elif vec.y>=get_parent().get_parent().get_rect().size.y:
		return true
	else:
		return false

func can_move_down():
	var new_x = get_parent().position.x + position.x
	var new_y = get_parent().position.y + position.y
	
	if Global.inactive.has(Vector2(new_x, new_y+Global.grid)) or new_y==Global.max_y:
		inactivate_it()
		return false
	else:
		return true
		
func can_move_left():
	var new_x = get_parent().position.x + position.x
	var new_y = get_parent().position.y + position.y
	
	if new_x == 0 or (Global.inactive.has(Vector2(new_x-Global.grid, new_y))) or not is_active:
		return false
	else:
		return true
		
func can_move_right():
	var new_x = get_parent().position.x + position.x
	var new_y = get_parent().position.y + position.y
	
	if new_x==Global.max_x or (Global.inactive.has(Vector2(new_x+Global.grid, new_y))) or not is_active:
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
	var line_vals=indexes
	for i in range(line_vals.size()-1,-1,-1):
		Global.inactive.remove(line_vals[i])
		Global.inactive_blocks[line_vals[i]].destroy_block()
		Global.inactive_blocks.remove(line_vals[i])

func shift_blocks(blocks):
	for i in blocks:
		Global.inactive[i].y += Global.grid
		Global.inactive_blocks[i].position.y += Global.grid
	
func destroy_block():
	queue_free()
