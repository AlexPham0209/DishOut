extends Control

@onready var score = $Score
var growth = 0

func _ready() -> void:
	Global.grow.connect(change_text)
	score.text = str(growth)
	
func change_text(amount):
	growth += amount
	score.text = str(growth)
