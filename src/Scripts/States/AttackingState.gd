class_name AttackingState
extends State
@export var chase_speed : float
@export var stages : Stages

func physics_update(delta):
	var e = entity as Cell
	var direction : Vector2 = (Global.player.global_position - e.global_position).normalized()
	e.velocity = direction * chase_speed
	stages.sprite.flip_v = direction.angle() >= PI
	e.rotation = direction.angle()
