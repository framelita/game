extends Control

func _ready():
	pass

func _on_StartButton_pressed():
	$SFXTap.play()
	Global.start_game()
