extends Cell

@onready var sprite = $Icon
@export var witness_state : State
var chase_speed : float = 300

func attacking():
	var direction = (Global.player.global_position - self.global_position).normalized()
	self.velocity = direction * chase_speed
	
func fleeing():
	var direction = (Global.player.global_position - self.global_position).normalized()
	self.velocity = -direction * chase_speed
	
func _on_survey_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return
		
	var player : Amoeba = area.get_parent() 
	player.notify_cells.connect(initiate_chase)


#If it is outside of area, leave it out of callable
func _on_survey_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return
		
	var player : Amoeba = area.get_parent() 
	player.notify_cells.disconnect(initiate_chase)
	state = State.Roaming

	
func initiate_chase():
	print("Start Chase")
	state = witness_state
	sprite.modulate = Color(1, 0, 0)
