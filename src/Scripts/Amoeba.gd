class_name Amoeba
extends CharacterBody2D

@export var growth_rate : float = 0.1
@export var speed : float = 10
@export var acceleration : float = 0.25
@export var friction : float = 0.25
@export var max_growth = 100

@onready var camera = $Camera2D
var growth : float
var total : float = 0

func _ready() -> void:
	growth = growth_rate

func _physics_process(delta: float) -> void:
	self.move()
	self.grow(delta)
	self.move_and_slide()

func move():
	var x = Input.get_axis("Left", "Right")
	var y = Input.get_axis("Up", "Down")
	
	var direction = Vector2(x, y)
	
	if direction.length() != 0:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		velocity.y = move_toward(velocity.y, direction.y * speed, acceleration)
		
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
		velocity.y = move_toward(velocity.y, 0, friction)
	
func grow(delta):
	if total >= max_growth:
		print("Max growth.  Continue to next level")
		return 
		
	if not Input.is_action_pressed("Interact"):
		return
	
	total += growth
	self.scale += Vector2(growth, growth) * delta
	growth *= 1.01
	
	camera.zoom -= Vector2(growth_rate, growth_rate) * delta
	
