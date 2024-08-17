class_name Invincibility
extends Timer

@export var is_invincible : bool = false

func start_invincibility():
	is_invincible = true
	self.start()
	
func _on_timeout() -> void:
	is_invincible = false
