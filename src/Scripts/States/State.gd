class_name State
extends Node2D

var entity : Node2D
signal transition_to(state_name : String, param : Dictionary)
var state_machine : StateMachine

func enter(param : Dictionary = {}):
	pass
	
func exit():
	pass

func update(delta):
	pass
	
func physics_update(delta):
	pass
	
func input(event):
	pass
