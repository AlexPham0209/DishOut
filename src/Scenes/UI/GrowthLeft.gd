extends Control

@onready var score = $Score

func _ready() -> void:
	Global.grow.connect(change_text)
	
func change_text(amount):
	score.text = str(Global.amount_left - amount + 1) 
