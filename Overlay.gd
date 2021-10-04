extends Control

func _ready():
	$CenterContainer/VBoxContainer/Label.text = ""
	pass

func _on_StartButton_pressed():
	$SFXTap.play()
	if Global.game_over:
		Global.restart_game()
	else:
		Global.has_started_game = true
		Global.show_story()
