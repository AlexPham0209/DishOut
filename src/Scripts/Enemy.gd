class_name Enemy
extends Node2D

@export var total = 0


func _on_eat_area_area_entered(area: Area2D) -> void:
	var player : Amoeba = area.get_parent()

	if player is not Amoeba or player.scale < self.scale + Vector2(0.25, 0.25):
		return 
		
	queue_free()
