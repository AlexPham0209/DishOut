class_name Stages
extends Node2D

@export var sprite : Sprite2D
@export var stages : Array[Stage]

func _ready() -> void:
	sprite.visible = true

func choose_level(level):
	for stage in stages:
		if level >= stage.min and level < stage.max:
			if sprite != null:
				sprite.visible = false
				
			sprite = get_node(stage.sprite)
			sprite.visible = true
			return
