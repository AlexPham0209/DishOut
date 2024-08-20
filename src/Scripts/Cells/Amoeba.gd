class_name Amoeba
extends CharacterBody2D

@onready var sprite : Sprite2D = $Sprite
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var growth : Growth = $Growth
@export var camera : Camera2D

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
signal death
signal dash_event

var scale_tween : Tween
var rotate_tween : Tween

var blood : PackedScene = preload("res://src/Scenes/Trail/Blood.tscn")
var first_dash : bool = true


func _ready() -> void:
	start_speed = speed 
	start_scale = scale 
	start_zoom = camera.zoom
	self.scale = start_scale + (Vector2(scale_growth_rate, scale_growth_rate) * growth.value)
	camera.starting_scale = start_zoom - (Vector2(cam_growth_rate, cam_growth_rate) * growth.value)
	Global.grow.emit(growth.value)
	Global.player = self
	ability.entity = self


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Interact"):
		if first_dash:
			dash_event.emit()
			first_dash = true
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
		if not animation_player.is_playing():
			animation_player.play("Walk")
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		velocity.y = move_toward(velocity.y, direction.y * speed, acceleration)
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
	animation_player.play("TakeDamage")
	
func heal():
	grow(1)
		
func grow(amount):
	#Once reached max growth, then go to the next level
	growth.value += amount
	if not camera.zooming:
		camera.screen_shake()
	
	if growth.value <= 0:
		game_over()
		return
	
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
		
	if not camera.zooming:
		scale_tween.parallel().tween_property(camera, "zoom", new_zoom.clamp(Vector2(0.25, 0.25), Vector2.ONE), 1.0). \
			set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	scale_tween.play()
	
func spawn_blood():
	if get_tree() == null or get_tree().current_scene == null:
		return
		
	var instance = blood.instantiate()
	instance.global_position = self.global_position
	get_tree().current_scene.get_node("Blood").add_child(instance)

func game_over():
	spawn_blood()
	queue_free()
	await get_tree().create_timer(2.0)
	death.emit()
	
func pause():
	process_mode = Node.PROCESS_MODE_DISABLED
