extends Node2D

@export var entity : Node2D
@export var state_machine : StateMachine
@export var reaction_state : String

func enter_sight(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return
		
	var player : Amoeba = area.get_parent()
	
	if not player.notify_cells.is_connected(initiate_chase):
		player.notify_cells.connect(initiate_chase)


#If it is outside of area, leave it out of callable
func exit_sight(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return
		
	var player : Amoeba = area.get_parent() 
	player.notify_cells.disconnect(initiate_chase)
	state_machine.transition_to("Roaming", {})


func initiate_chase():
	state_machine.transition_to(reaction_state, {})
	
