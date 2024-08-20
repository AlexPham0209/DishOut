extends CanvasLayer

@export var level : PackedScene
@onready var animation_player = $AnimationPlayer
func _ready() -> void:
	animation_player.play("Open")
	
func _on_next_level_pressed() -> void:
	Transition.change_scene_fade(level)
