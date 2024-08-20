extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("Open")
	
func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
