class_name Enemy
extends Node2D

@export var total = 0
@export var margin : Vector2 = Vector2(0.25, 0.25)
var player : Amoeba = null

func _process(delta: float) -> void:
	if player != null and player.scale >= self.scale + margin:
		queue_free()
		
func _on_eat_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return 
	
	player = area.get_parent()

func _on_eat_area_area_exited(area: Area2D) -> void:
	player = null
