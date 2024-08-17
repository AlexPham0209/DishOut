extends CPUParticles2D

func _ready() -> void:
	self.self_modulate.h = randf_range(0, 1)
	
func _on_timer_timeout() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
