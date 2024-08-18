class_name BoostAbility
extends Ability

@export var boost_speed : float
var dashing : bool

@onready var timer : Timer = $Timer
@onready var spawner : PackedScene = preload("res://src/Scenes/Trail/Trail.tscn")
var instance : Node2D = null

func execute():
	if dashing or entity.direction == Vector2.ZERO:
		return 
	
	dashing = true
	entity.dashing = true
	entity.speed = boost_speed
	entity.velocity = entity.direction * boost_speed 
	entity.camera.screen_shake()
	
	instance = spawner.instantiate()
	#instance.position = Vector2.ZERO
	entity.add_child(instance)
	instance.scale = entity.scale
	timer.start()


func _on_timer_timeout() -> void:
	dashing = false
	entity.dashing = false
	entity.speed = entity.start_speed
	instance.queue_free()
	instance = null
	finished()
