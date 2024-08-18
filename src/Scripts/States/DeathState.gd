class_name DeathState
extends State

@export var effects : Array[Effect]
@export var blood : PackedScene

func enter(param : Dictionary = {}):
	for effect in effects:
		if effect is Effect:
			effect.give_effect()
	
	var instance = blood.instantiate() 
	instance.global_position = owner.global_position 
	
	if get_tree() != null:
		get_tree().root.add_child(instance)
		get_tree().root.move_child(instance, 0)
	entity.queue_free()
