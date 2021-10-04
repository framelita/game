extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var _error = Global.connect("block_pressed", self, "block_pressed")
	var _error2 = Global.connect("block_released", self, "block_released")
	var _error3 = Global.connect("block_entered", self, "block_entered")
	var _error4 = Global.connect("block_exited", self, "block_exited")

func _process(delta):
	$CursorSprite.position = get_global_mouse_position()

func block_pressed():
	$CursorSprite.play('click')

func block_released():
	$CursorSprite.play('')
	
func block_entered():
	$CursorSprite.play('hover')

func block_exited():
	$CursorSprite.play('')
