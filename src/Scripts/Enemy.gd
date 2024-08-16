class_name Cell
extends CharacterBody2D

enum State {
	Roaming,
	Attacking,
	Fleeing,
	Death
}

@export var margin : Vector2 = Vector2(0.25, 0.25)
@export var distance = 64
@export var tolerance : float = 0.5
@export var speed : float = 50

var player : Amoeba = null
var state : State = State.Roaming
var target_position : Vector2

func _ready() -> void:
	target_position = global_position
	
func _process(delta: float) -> void:
	process_state()
	if player != null and player.scale >= self.scale + margin:
		state = State.Death
	move_and_slide()

func process_state():
	match(state):
		State.Roaming:
			roaming()
		State.Attacking:
			attacking()
		State.Fleeing:
			fleeing()
		State.Death:
			death()
			
func roaming():
	var direction = (target_position - global_position).normalized()
	self.velocity = direction * speed
	
	#Find new target to follow
	if is_at_target_position():
		change_target_position()
	
func death():
	player.notify_cells.emit()
	player.grow(0.5)
	queue_free()

func attacking():
	pass
	
func fleeing():
	pass
	
func _on_eat_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return 
	
	player = area.get_parent()

func _on_eat_area_area_exited(area: Area2D) -> void:
	player = null

func change_target_position():
	var target_vector = Vector2(randf_range(-distance, distance), randf_range(-distance, distance))
	target_position += target_vector
	
func is_at_target_position():
	return (target_position - global_position).length() < tolerance
