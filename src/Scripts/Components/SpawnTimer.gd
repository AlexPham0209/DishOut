extends Timer

@export var enemies : Array[PackedScene]
@export var distance : int

func _on_timeout() -> void:
	var i = randi() % enemies.size()
	var instance = enemies[i].instantiate() as Cell
	instance.global_position = owner.global_position + Vector2(randf_range(-distance, distance), randf_range(-distance, distance))
	get_tree().current_scene.add_child(instance)
	instance.invincibility.start_invincibility()
