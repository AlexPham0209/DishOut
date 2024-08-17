class_name GrowEffect
extends Effect

@export var rate : int = 1

func give_effect():
	Global.player.grow(1)
