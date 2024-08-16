class_name StateMachine
extends Node2D

var states : Dictionary
var current_state : State
@export var initial_state : String
@export var entity : Node2D

func _ready():
	for state in get_children().filter(func(state): return state is State):
		states[state.name] = state
		state.transition_to.connect(transition_to)
		state.entity = entity as Node2D
		state.state_machine = self
		
	self.current_state = states[initial_state]
	current_state.enter()

func _physics_process(delta):
	current_state.physics_update(delta)
	
func _process(delta):
	current_state.update(delta)
	
func _input(event):
	current_state.input(event)
	
func transition_to(state_name : String, param : Dictionary):
	if not states.has(state_name):
		return
	
	current_state.exit()
	current_state = states[state_name]
	current_state.enter(param)
