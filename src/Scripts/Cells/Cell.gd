class_name Cell
extends CharacterBody2D

@export var margin : Vector2 = Vector2(0.25, 0.25)
@onready var state_machine : StateMachine = $States
@onready var stages : Stages = $Stages
@onready var growth = $Growth
@onready var invincibility : Invincibility = $Invincibility
@export var death_state : String = "Death"
var walk_tween : Tween
var playing : bool = false

@export var growth_rate : float = 0.5
var scale_tween : Tween
var start_scale : Vector2

@export var min : int
@export var max : int

signal eaten

func _ready() -> void:
	start_scale = self.scale
	growth.value = randi_range(min, max)
	self.scale = start_scale + (Vector2(growth_rate, growth_rate) * growth.value)
	stages.choose_level.call_deferred(growth.value)

func _process(delta: float) -> void:
	if velocity != Vector2.ZERO:
		walk_animation()
	elif walk_tween != null:
		walk_tween.stop()
		
	move_and_slide()

func walk_animation():
	if playing:
		return
	
	playing = true
	walk_tween = create_tween()
	var sprite = stages.sprite
	var start = sprite.scale
	var stretched = sprite.scale + Vector2(0.1, -0.1)
	walk_tween.tween_property(sprite, "scale", stretched, 0.5).set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	walk_tween.tween_property(sprite, "scale", start, 0.5).set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
		
	walk_tween.play()
	await walk_tween.finished
	playing = false
	
func damage():
	eaten.emit()
	state_machine.transition_to(death_state, {})
		
func grow(amount):
	#Once reached max growth, then go to the next level
	growth.value += amount

	#Calculate new scale
	var new_scale = start_scale + (Vector2(growth_rate, growth_rate) * growth.value)
	#Procedurally animate the scale of the player and the zoom of the camera to new sizes
	scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", new_scale, 1.0). \
		set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.play()
	
