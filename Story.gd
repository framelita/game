extends Control

var current_phrase: int = 0
onready var total_phrases: int = $Phrases.get_child_count()

var story1 := preload("res://assets/graphics/story1.png")
var story2 := preload("res://assets/graphics/story2.png")
var story3 := preload("res://assets/graphics/story3.png")

func _ready():
	next_phrase()
	pass

func _input(_event):
	if Input.is_action_just_released("ui_accept") or Input.is_action_just_released("left_click"):
		print("startedf", Global.has_started_game, current_phrase)
		if not Global.has_seen_tutorial and Global.has_started_game: 
			next_phrase()

func next_phrase():
	print("current phrase is", current_phrase)
	if current_phrase < total_phrases:
		$BG/RichTextLabel.bbcode_text = $Phrases.get_children()[current_phrase].text
		current_phrase += 1
	else:
		show_tutorial()
	if current_phrase > 2:
		$BG.texture = story2
	if current_phrase > 5:
		$BG.texture = story3

func show_tutorial():
	$Tutorial.show()
	$Tutorial/Upset/AnimationPlayer.play("angry")
	$BG.hide()

func _on_StartButton_pressed():
	$Tutorial.hide()
	$Tutorial/Upset/AnimationPlayer.stop()
	hide()
	Global.start_game()
