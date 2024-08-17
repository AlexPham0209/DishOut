extends State

@export var amount : int
@export var enemy : PackedScene
@export var distance : int

func enter(param : Dictionary = {}):
	for i in range(amount):
		var instance = enemy.instantiate() as Cell
		instance.global_position = owner.global_position + Vector2(randf_range(-distance, distance), randf_range(-distance, distance))
		get_tree().current_scene.add_child(instance)
		instance.state_machine.initial_state = "Fleeing"
		instance.start_invinciblity(3)
	owner.queue_free()
