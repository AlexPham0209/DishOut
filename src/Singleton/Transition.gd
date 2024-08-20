extends Node

@onready var animation_player = $AnimationPlayer

func change_scene_fade(scene : PackedScene):
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(scene)
	animation_player.play_backwards("Fade")
	
