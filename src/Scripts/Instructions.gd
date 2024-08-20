extends RichTextLabel
var tween : Tween
@export var frequency : int = 20

func show_text():
	if tween:
		tween.kill()
	
	var speed = text.length()/frequency
	self.visible_characters = 0
	
	tween = create_tween()
	tween.tween_property(self,"visible_characters", self.text.length(), speed).set_trans(Tween.TRANS_LINEAR)
	tween.play()
	
	await tween.finished
	
func hide_text():
	self.visible = false
