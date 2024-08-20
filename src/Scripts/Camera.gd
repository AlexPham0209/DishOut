extends Camera2D

signal finish_zoom_in
signal finish_zoom_out

@export var NOISE_SHAKE_SPEED: float = 30.0
@export var NOISE_SHAKE_STRENGTH: float = 60.0
@export var SHAKE_DECAY_RATE: float = 3.0
@export var time = 0.25

@onready var noise = FastNoiseLite.new()
@onready var animation_player = $AnimationPlayer
var starting_scale
var zoom_tween : Tween
var zooming : bool = false

var noise_i: float = 0.0
var shake_strength: float = 0.0
var tween : Tween 

func screen_shake(strength : float = NOISE_SHAKE_STRENGTH, time : float = time):
	if zoom_tween:
		return
		
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "shake_strength", strength, time).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "shake_strength", 0, time).set_ease(Tween.EASE_IN_OUT)

#func _process(delta):
#	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
#	var shake_offset = get_random_offset()
#	self.offset = shake_offset

func get_random_offset() -> Vector2:
	return Vector2(
		randf_range(-shake_strength, shake_strength),
		randf_range(-shake_strength, shake_strength)
	)

func enter_level():
	zooming = true
	self.zoom = Vector2(0.1, 0.1)
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, "zoom", starting_scale, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC) 
	zoom_tween.play()
	await zoom_tween.finished
	finish_zoom_in.emit()
	zooming = false

	
func exit_level():
	#if zoom_tween:
		#zoom_tween.kill()
	zooming = true
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, "zoom", Vector2(0.1, 0.1), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	zoom_tween.play()
	await zoom_tween.finished
	finish_zoom_out.emit()
	zooming = false
