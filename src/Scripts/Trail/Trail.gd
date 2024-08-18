extends Node2D

@export var texture : PackedScene


func _on_timeout() -> void:
	var instance = texture.instantiate()
	instance.global_position = self.global_position
	if get_tree() != null:
		get_tree().root.add_child(instance)
		get_tree().root.move_child(instance, 0)
