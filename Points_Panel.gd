extends Node2D

func _ready():
	$RichTextLabel.bbcode_text = str(Global.points).pad_zeros(6)
	Global.connect("add_points", self, "add_points")
	Global.connect("update_stage", self, "update_stage")

func add_points():
	$RichTextLabel.bbcode_text = str(Global.points).pad_zeros(6)
	
func update_stage():
	$StageLabel.bbcode_text = "Stage: " + str(Global.stage)
