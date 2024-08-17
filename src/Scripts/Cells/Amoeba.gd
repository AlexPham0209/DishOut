class_name Amoeba
extends CharacterBody2D

@onready var sprite : Sprite2D = $Sprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@export var speed : float = 300
@export var acceleration : float = 25
@export var friction : float = 10

@export var max_growth = 20
@export var cam_growth_rate : float = 0.5
@export var scale_growth_rate : float = 1
@export var growth : int
@export var min : float

@onready var camera = $Camera2D
var start_scale : Vector2
var start_zoom : Vector2

signal notify_cells

var scale_tween : Tween
var rotate_tween : Tween

func _ready() -> void:
	start_scale = scale
	start_zoom = camera.zoom
	scale = start_scale + (Vector2(growth, growth) * scale_growth_rate)
	camera.zoom = (start_zoom - (Vector2(growth, growth) * cam_growth_rate)).clamp(Vector2(min, min), Vector2.ONE)
	Global.player = self


func _physics_process(delta: float) -> void:
	self.move()
	
	if Input.is_action_just_pressed("Interact"):
		grow(1)
		
	self.move_and_slide()

func move():
	var x = Input.get_axis("Left", "Right")
	var y = Input.get_axis("Up", "Down")
	
	var direction = Vector2(x, y)
	
	#Add friction and acceleration
	if direction.length() != 0:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		velocity.y = move_toward(velocity.y, direction.y * speed, acceleration)
		animation_player.play("Walk")
		rotate_sprite(direction.angle())
		
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		animation_player.stop()
		velocity.y = move_toward(velocity.y, 0, friction)


func rotate_sprite(angle):
	sprite.flip_v = angle >= PI
	rotate_tween = create_tween()
	rotate_tween.tween_property(self, "rotation", angle, 0.25). \
		set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	rotate_tween.play()
	
func grow(amount):
	#Once reached max growth, then go to the next level
	growth += amount
	camera.screen_shake()
	
	if growth >= max_growth:
		print("Max growth.  Continue to next level")
		return 
	
	if growth < 0:
		queue_free()
	 
	notify_cells.emit()
	
	#Calculate new scale
	var new_scale = start_scale + (Vector2(growth, growth) * scale_growth_rate)
	var new_zoom = (start_zoom - (Vector2(growth, growth) * cam_growth_rate)).clamp(Vector2(min, min), Vector2.ONE)

	#Procedurally animate the scale of the player and the zoom of the camera to new sizes
	scale_tween = create_tween()
	scale_tween.parallel().tween_property(self, "scale", new_scale, 1.0). \
		set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.parallel().tween_property(camera, "zoom", new_zoom, 1.0). \
		set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.play()
	
