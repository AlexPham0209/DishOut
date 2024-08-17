class_name Cell
extends CharacterBody2D

@export var margin : Vector2 = Vector2(0.25, 0.25)
@onready var state_machine : StateMachine = $States
@onready var death_state : State = $States/Death
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var growth = $Growth
@onready var invincibility : Invincibility = $Invincibility

@export var growth_rate : float = 0.5
var scale_tween : Tween
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
		
func grow(amount):
	#Once reached max growth, then go to the next level
	growth.value += amount

	#Calculate new scale
	var new_scale = start_scale + (growth.get_vector() * growth_rate)
	#Procedurally animate the scale of the player and the zoom of the camera to new sizes
	scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", new_scale, 1.0). \
		set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.play()
	
