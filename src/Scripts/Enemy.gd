class_name Cell
extends CharacterBody2D

@export var margin : Vector2 = Vector2(0.25, 0.25)
@onready var state_machine : StateMachine = $States
var player : Amoeba = null
	
func _process(delta: float) -> void:
	if player != null and player.scale >= self.scale + margin:
		state_machine.transition_to("Death", {})
	move_and_slide()

func player_enter(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return 
	
	player = area.get_parent()

func player_exit(area: Area2D) -> void:
	player = null
