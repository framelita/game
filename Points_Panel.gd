extends Node2D

func _ready():
	$RichTextLabel.bbcode_text = str(Global.points).pad_zeros(6)
	Global.connect("add_points", self, "add_points")

func add_points():
	$RichTextLabel.bbcode_text = str(Global.points).pad_zeros(6)
