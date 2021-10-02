extends Shape0
class_name Shape7

func _ready():
	rotation_matrix=[
	[Vector2(-Global.grid,0),Vector2(0,0),Vector2(0,-Global.grid),Vector2(Global.grid,-Global.grid)],
	[Vector2(0,-Global.grid),Vector2(0,0),Vector2(Global.grid,0),Vector2(Global.grid,Global.grid)],
	[Vector2(Global.grid,0),Vector2(0,0),Vector2(0,Global.grid),Vector2(-Global.grid,Global.grid)],
	[Vector2(0,Global.grid),Vector2(0,0),Vector2(-Global.grid,0),Vector2(-Global.grid,-Global.grid)]
	]
	draw_shape()
	rotate_position=1
