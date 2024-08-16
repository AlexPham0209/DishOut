extends CharacterBody2D

@export var growth_rate : float = 0.25
@export var speed : float = 10
@export var acceleration : float = 0.25

@onready var camera = $Camera2D

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	self.move()
	self.grow()
	self.move_and_slide()

func move():
	var x = Input.get_axis("Left", "Right")
	var y = Input.get_axis("Up", "Down")
	
	var direction = Vector2(x, y)
	
	if direction.length() != 0:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration)
		velocity.y = move_toward(velocity.y, direction.y * speed, acceleration)
	
func grow():
	if not Input.is_action_pressed("Interact"):
		return
	
	self.scale += Vector2(growth_rate, growth_rate)
	camera.zoom -= Vector2(growth_rate, growth_rate)
