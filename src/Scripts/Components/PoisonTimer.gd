class_name PoisonTimer
extends Timer

var tick : int = 1
@export var ticks : int
signal take_damage(amount)


func _on_timeout() -> void:
	if tick >= ticks:
		queue_free()
		
	tick += 1 
	take_damage.emit(-1)
	self.start()
