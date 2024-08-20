extends Node2D

var i = 0
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@export var events : Array[String]
@export var next_scene : PackedScene

func _ready() -> void:
	play_next()

func play_next():
	if i >= events.size():
		return
	
	animation_player.play(events[i])
	i += 1 

func change_scene():
	Transition.change_scene_fade(next_scene)
