extends Node2D

@export var texture : PackedScene


func _on_timeout() -> void:
	var instance = texture.instantiate()
	instance.global_position = self.global_position
	if get_tree() != null and get_tree().current_scene != null:
		get_tree().current_scene.add_child(instance)
		get_tree().current_scene.move_child(instance, 0)
