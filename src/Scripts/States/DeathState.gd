extends State

func enter(param : Dictionary = {}):
	Global.player.grow(1)
	entity.queue_free()
