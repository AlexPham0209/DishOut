extends State

func enter(param : Dictionary = {}):
	Global.player.grow(0.5)
	entity.queue_free()
