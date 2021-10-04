extends Control

func _ready():
	$CenterContainer/VBoxContainer/Label.text = ""
	pass

func _on_StartButton_pressed():
	$SFXTap.play()
	if not Global.has_started_game:
		Global.has_started_game = true
		Global.show_story()
	elif Global.game_over:
		Global.restart_game()
	else:
		Global.start_game()
