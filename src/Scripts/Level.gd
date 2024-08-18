extends Node2D

@export var amount : int
var amount_left : int :
	set(value):
		amount_left = value
		set_amount_left(value)
	get:
		return amount_left
		
@export var spawns : Array[SpawnData]

@export var next_level : PackedScene
@export var margin : Vector2 = Vector2(0, 0)

@onready var spawn_points = $SpawnPoints
@onready var top_left : Marker2D = $Limits/TopLeft
@onready var bottom_right : Marker2D = $Limits/BottomRight

signal update_amount_left(value)

func _ready() -> void:
	Global.grow.connect(subtract_growth)
	amount_left = amount
	spawn_enemies()

func spawn_enemies():
	for data in spawns:
		var type = data.type
		var amount = data.amount
		
		for i in range(amount):
			var instance = type.instantiate() as Cell
			var spawn_point = spawn_points.get_children().pick_random()
			var x = spawn_point.global_position.x + randf_range(0, margin.x)
			var y = spawn_point.global_position.y + randf_range(0, margin.y)
			var growth = randi_range(data.min_size, data.max_size)
			
			instance.global_position = Vector2(x, y)
			instance.scale = instance.scale + (Vector2(instance.growth_rate, instance.growth_rate) * growth)
			get_tree().current_scene.get_node("Enemies").add_child(instance)
			instance.growth.value = growth

func subtract_growth(amount):
	amount_left -= amount
		
func set_amount_left(value):
	update_amount_left.emit(value)
	
	if amount_left <= 0:
		finish_level()
		return
	

func finish_level():
	get_tree().change_scene_to_packed(next_level)
