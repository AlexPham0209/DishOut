class_name DeathState
extends State

@export var effects : Array[Effect]

func enter(param : Dictionary = {}):
	for effect in effects:
		if effect is Effect:
			effect.give_effect()
			
	entity.queue_free()
