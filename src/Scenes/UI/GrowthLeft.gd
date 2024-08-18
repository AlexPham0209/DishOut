extends Control

@onready var score = $Score
	
func change_text(amount):
	score.text = str(amount) 
