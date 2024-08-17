class_name Cell
extends CharacterBody2D

@export var margin : Vector2 = Vector2(0.25, 0.25)
@onready var state_machine : StateMachine = $States
@onready var death_state : State = $States/Death
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var growth = $Growth
@onready var invincibility : Invincibility = $Invincibility

@export var growth_rate : float = 0.5
var start_scale : Vector2

signal eaten

func _ready() -> void:
	self.start_scale = self.scale
	self.scale = start_scale + (Vector2(growth.value, growth.value) * growth_rate)

func _process(delta: float) -> void:
	if velocity != Vector2.ZERO:
		animation_player.play("Walk")
	else:
		animation_player.stop()
		
	move_and_slide()

func damage():
	eaten.emit()
	state_machine.transition_to("Death", {})
		
