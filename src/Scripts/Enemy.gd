class_name Cell
extends CharacterBody2D

@export var margin : Vector2 = Vector2(0.25, 0.25)
@onready var state_machine : StateMachine = $States
@onready var death_state : State = $States/Death

@export var growth_rate : float = 0.5
@export var growth : int
var start_scale : Vector2

var player : Amoeba = null

var invincibility_tween : Tween
@export var is_invincible : bool = false

signal eaten

func _ready() -> void:
	self.start_scale = self.scale
	self.scale = start_scale + (Vector2(growth, growth) * growth_rate)

func _process(delta: float) -> void:
	if player != null and player.growth >= self.growth:
		eaten.emit()
		state_machine.transition_to("Death", {})
		
	move_and_slide()

func player_enter(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return 
	
	player = area.get_parent()

func player_exit(area: Area2D) -> void:
	player = null

func start_invinciblity(time : float):
	is_invincible = true
	print("invincible")
	invincibility_tween = create_tween()
	invincibility_tween.tween_property(self, "is_invincible", false, time)
	invincibility_tween.play()
	await invincibility_tween.finished
	print("normal :(")
