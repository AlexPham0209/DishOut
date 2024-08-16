class_name Amoeba
extends CharacterBody2D

@export var growth_rate : float = 0.1
@export var speed : float = 10
@export var acceleration : float = 0.25
@export var friction : float = 0.25
@export var max_growth = 100

@onready var camera = $Camera2D
var growth : float
var total : float = 1

signal notify_cells

var scale_tween : Tween

func _ready() -> void:
	Global.player = self
	growth = growth_rate

func _physics_process(delta: float) -> void:
	self.move()
	self.move_and_slide()

func move():
	var x = Input.get_axis("Left", "Right")
	var y = Input.get_axis("Up", "Down")
	
	var direction = Vector2(x, y)
	
	#Add friction and acceleration
	if direction.length() != 0:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		velocity.y = move_toward(velocity.y, direction.y * speed, acceleration)
		
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		velocity.y = move_toward(velocity.y, 0, friction)
	
func grow(amount):
	#Once reached max growth, then go to the next level
	if total >= max_growth:
		print("Max growth.  Continue to next level")
		return 

	#Increment total growth
	total += amount
	notify_cells.emit()
	
	#Calculate new scale
	var new_scale = self.scale + Vector2(amount, amount)
	var new_zoom = camera.zoom - (Vector2(amount, amount) * 0.1)
	
	#Procedurally animate the scale of the player and the zoom of the camera to new sizes
	scale_tween = create_tween()
	scale_tween.parallel().tween_property(self, "scale", new_scale, 1.0). \
		set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.parallel().tween_property(camera, "zoom", new_zoom, 1.0). \
		set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.play()
	
