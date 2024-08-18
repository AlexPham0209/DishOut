class_name Amoeba
extends CharacterBody2D

@onready var sprite : Sprite2D = $Sprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var growth : Growth = $Growth
@onready var camera = $Camera2D

var start_speed : float
var direction : Vector2
@export var speed : float = 300
@export var acceleration : float = 25
@export var friction : float = 10

@export var max_growth = 20
@export var cam_growth_rate : float = 0.5
@export var scale_growth_rate : float = 1
@export var min : float
@export var ability : Ability

var start_scale : Vector2
var start_zoom : Vector2
var dashing : bool = false

signal notify_cells

var scale_tween : Tween
var rotate_tween : Tween

func _ready() -> void:
	start_speed = speed 
	start_scale = scale 
	start_zoom = camera.zoom
	self.scale = start_scale + (Vector2(scale_growth_rate, scale_growth_rate) * growth.value)
	camera.zoom = start_zoom - (Vector2(cam_growth_rate, cam_growth_rate) * growth.value)
	Global.grow.emit(growth.value)
	Global.player = self
	ability.entity = self


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		ability.execute()
		
	self.move()
	self.move_and_slide()

func move():
	if dashing:
		return
		
	var x = Input.get_axis("Left", "Right")
	var y = Input.get_axis("Up", "Down")
	
	direction = Vector2(x, y)
	
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

func damage():
	grow(-1)
	
func heal():
	grow(1)
		
func grow(amount):
	#Once reached max growth, then go to the next level
	growth.value += amount
	camera.screen_shake()
	
	if growth.value <= 0:
		queue_free()
	
	notify_cells.emit()
	Global.grow.emit(amount)
	
	var new_scale = start_scale + (Vector2(scale_growth_rate, scale_growth_rate) * growth.value)
	
	var change = 0.1/growth.value
	var new_zoom = start_zoom - (Vector2(0.1, 0.1) * growth.value) if camera.zoom >= Vector2(0.75, 0.75) else \
		Vector2(0.75, 0.75) - (Vector2(0.025, 0.025) * (growth.value + int(change) - 1))

	#Procedurally animate the scale of the player and the zoom of the camera to new sizes
	scale_tween = create_tween()
	scale_tween.parallel().tween_property(self, "scale", new_scale, 1.0). \
		set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.parallel().tween_property(camera, "zoom", new_zoom.clamp(Vector2(0.25, 0.25), Vector2.ONE), 1.0). \
		set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.play()
	
