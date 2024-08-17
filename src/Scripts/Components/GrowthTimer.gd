extends Timer

signal grow(amount : int)

@export var max_growth : int
@export var growth_amount : int
var i = 0

func _on_timeout() -> void:
	if i >= max_growth - 1:
		return
		
	i += 1
	grow.emit(growth_amount)
	self.start()
