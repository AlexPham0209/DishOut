extends Node2D

@export var amount_left : int
@export var spawns : Array[SpawnData]
@onready var top_left : Marker2D = $Limits/TopLeft
@onready var bottom_right : Marker2D = $Limits/BottomRight

func _ready() -> void:
	Global.amount_left = amount_left
	spawn_enemies()

func spawn_enemies():
	for data in spawns:
		var type = data.type
		var amount = data.amount
		
		for i in range(amount):
			var instance = type.instantiate() as Cell
			var x = randf_range(top_left.global_position.x, bottom_right.global_position.x)
			var y = randf_range(bottom_right.global_position.y, top_left.global_position.y)
			var growth = randi_range(data.min_size, data.max_size)
			
			instance.global_position = Vector2(x, y)
			get_tree().current_scene.add_child(instance)
			instance.scale = instance.start_scale + (Vector2(growth, growth) * instance.growth_rate)
