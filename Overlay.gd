extends Control

func _ready():
	pass

func _on_StartButton_pressed():
	$SFXTap.play()
	if Global.game_over:
		Global.restart_game()
	else:
		Global.start_game()
