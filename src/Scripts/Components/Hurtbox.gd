class_name Hurtbox
extends Area2D

signal take_damage()

@export var growth : Growth
@export var invincibility : Invincibility

func _process(delta: float) -> void:
	if get_overlapping_areas().size() <= 0 or invincibility.is_invincible:
		return
		
	var body = get_overlapping_areas()[0] as Hurtbox
	
	if growth.value > body.growth.value:
		return
	
	take_damage.emit()
	invincibility.start_invincibility()
