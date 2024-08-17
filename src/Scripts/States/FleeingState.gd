class_name FleeingState
extends State
@export var sprite : Sprite2D
@export var chase_speed : float


func physics_update(delta):
	var e = entity as Cell
	var direction : Vector2 = (Global.player.global_position - e.global_position).normalized()
	e.velocity = -direction * chase_speed
	sprite.flip_v = direction.angle() >= PI
	e.rotation = direction.angle()
