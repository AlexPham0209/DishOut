extends Control

@onready var score = $Score
	
func change_text(amount):
	if score != null:
		score.text = str(amount) 
