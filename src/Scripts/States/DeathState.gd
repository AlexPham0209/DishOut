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
	
	if get_tree() != null and get_tree().current_scene != null:
		get_tree().current_scene.get_node("Blood").add_child(instance)
	entity.queue_free()
