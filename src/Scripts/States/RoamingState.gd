extends State

var target_position : Vector2

@export var distance = 64
@export var tolerance : float = 0.5
@export var speed : float = 50

func physics_update(delta):
	var e = entity as Cell
	var direction = (target_position - e.global_position).normalized()
	e.velocity = direction * speed
	
	#Find new target to follow
	if is_at_target_position():
		change_target_position()

func change_target_position():
	var target_vector = Vector2(randf_range(-distance, distance), randf_range(-distance, distance))
	target_position += target_vector
	
func is_at_target_position():
	return (target_position - entity.global_position).length() < tolerance
