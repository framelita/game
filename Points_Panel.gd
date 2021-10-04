extends Node2D

func _ready():
	$RichTextLabel.bbcode_text = str(Global.points).pad_zeros(6)
	var _error = Global.connect("add_points", self, "add_points")
	var _error2 = Global.connect("update_stage", self, "update_stage")

func add_points():
	$RichTextLabel.bbcode_text = str(Global.points).pad_zeros(6)
	
func update_stage():
	$ScoreLabel.text = str(Global.points)
	$NextStageLabel.text = str(Global.target_score)
	$Stage/Label.text = str(Global.stage)
