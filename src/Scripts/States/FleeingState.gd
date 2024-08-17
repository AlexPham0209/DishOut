extends State
@export var chase_speed : float

func physics_update(delta):
	var e = entity as Cell
	var direction = (Global.player.global_position - e.global_position).normalized()
	e.velocity = -direction * chase_speed
