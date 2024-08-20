extends CanvasLayer


func _on_start_pressed() -> void:
	Transition.change_scene_fade_file("res://src/Scenes/Cutscenes/Scene1.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
