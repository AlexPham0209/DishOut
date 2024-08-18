extends State

@export var amount : int
@export var enemy : PackedScene
@export var distance : int

func enter(param : Dictionary = {}):
	for i in range(amount):
		var instance = enemy.instantiate() as Cell
		instance.global_position = owner.global_position + Vector2(randf_range(-distance, distance), randf_range(-distance, distance))
		if get_tree() != null:
			get_tree().root.add_child(instance)
		instance.state_machine.transition_to("Fleeing", {})
		instance.invincibility.start_invincibility()
	owner.queue_free()
