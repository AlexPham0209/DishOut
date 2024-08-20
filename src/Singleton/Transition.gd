extends Node

@onready var animation_player = $AnimationPlayer

func change_scene_fade(scene : PackedScene):
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed(scene)
	animation_player.play_backwards("Fade")
	


func change_scene_fade_file(scene : String):
	animation_player.play("Fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(scene)
	animation_player.play_backwards("Fade")
	
