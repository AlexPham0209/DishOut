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
	get_tree().current_scene.add_child(instance)
	get_tree().current_scene.move_child(instance, 0)
	entity.queue_free()
