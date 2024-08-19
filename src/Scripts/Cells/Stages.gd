class_name Stages
extends Node2D

@export var sprite : Sprite2D
@export var stages : Array[Stage]
@export var palette : GradientTexture1D

func _ready() -> void:
	sprite.visible = true
	for child in get_children():
		child.material.set_shader_parameter("gradient", palette)

func choose_level(level):
	for stage in stages:
		if level >= stage.min and level < stage.max:
			if sprite != null:
				sprite.visible = false
				
			sprite = get_node(stage.sprite)
			sprite.visible = true
			return
