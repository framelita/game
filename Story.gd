extends Control

var current_phrase: int = 0
onready var total_phrases: int = $Phrases.get_child_count()

func _ready():
	next_phrase()

func next_phrase():
	if current_phrase < total_phrases:
		$BG/RichTextLabel.bbcode_text = $Phrases.get_children()[current_phrase].text
		current_phrase += 1
	else:
		show_tutorial()
		hide()

func show_tutorial():
	
