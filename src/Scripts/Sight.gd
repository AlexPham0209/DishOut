extends Area2D

@export var entity : Node2D
@export var state_machine : StateMachine

func enter_sight(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return
		
	var player : Amoeba = area.get_parent() 
	player.notify_cells.connect(initiate_chase)


#If it is outside of area, leave it out of callable
func exit_sight(area: Area2D) -> void:
	if area.get_parent() is not Amoeba:
		return
		
	var player : Amoeba = area.get_parent() 
	player.notify_cells.disconnect(initiate_chase)
	state_machine.transition_to("Roaming", {})


func initiate_chase():
	print("Start Chase")
	state_machine.transition_to("Attacking", {})
	
