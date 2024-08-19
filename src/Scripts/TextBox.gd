extends Control

signal finished_text 
var tween : Tween
@onready var text : Label = $Text
@onready var button = $Button
@export var frequency : int = 10
	
func set_text(val : String):
	if tween:
		tween.kill()
	
	text.text = val
	var speed = text.text.length()/frequency
	text.visible_characters = 0
	
	tween = create_tween()
	tween.tween_property(text,"visible_characters", text.text.length(), speed).set_trans(Tween.TRANS_LINEAR)
	tween.play()
	
	await tween.finished
	button.visible = true
	finished_text.emit()
