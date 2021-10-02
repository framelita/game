extends Shape0
class_name Shape1

func _ready():
	rotation_matrix=[
	[Vector2(-Global.grid,0),Vector2(0,0),Vector2(Global.grid,0),Vector2(2*Global.grid,0)],
	[Vector2(0,Global.grid),Vector2(0,0),Vector2(0,-Global.grid),Vector2(0,-2*Global.grid)],
	[Vector2(Global.grid,0),Vector2(0,0),Vector2(-Global.grid,0),Vector2(-2*Global.grid,0)],
	[Vector2(0,-Global.grid),Vector2(0,0),Vector2(0,Global.grid),Vector2(0,2*Global.grid)]
	]
	draw_shape()
	rotate_position=1
