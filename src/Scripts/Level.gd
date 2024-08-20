extends Node2D

@export var amount : int
var amount_left : int :
	set(value):
		amount_left = max(0, value)
		set_amount_left(value)
	get:
		return amount_left
		
@export var spawns : Array[SpawnData]

@export var next_level : PackedScene
@export var margin : Vector2 = Vector2(0, 0)

@onready var enemies = $Enemies
@onready var spawn_points = $SpawnPoints
@onready var top_left : Marker2D = $Limits/TopLeft
@onready var bottom_right : Marker2D = $Limits/BottomRight
@onready var animation_player = $AnimationPlayer
@onready var player = $Amoeba
@onready var text = $UI/Control/GrowthText
var next_level_screen = preload("res://src/Scenes/NextLevelScreen.tscn") 
var game_over_screen = preload("res://src/Scenes/GameOverScreen.tscn") 
var game_over_instance
var next_level_instance

signal update_amount_left(value)
signal enter_level
signal leave_level

func _ready() -> void:
	Global.grow.connect(subtract_growth)
	amount_left = amount
	enter_level.emit()
	text.set_growth(player.growth.value)
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

			instance.global_position = Vector2(x, y)
			instance.min = data.min_size
			instance.max = data.max_size
			
			enemies.add_child(instance)

func subtract_growth(amount):
	amount_left -= amount
		
func set_amount_left(value):
	update_amount_left.emit(value)
	
	if amount_left <= 0:
		finish_level()
		return
	
func finish_level():
	if next_level != null:
		leave_level.emit()

func show_next_level_screen():
	if next_level_instance:
		return
	next_level_instance = next_level_screen.instantiate()
	next_level_instance.level = next_level
	get_tree().current_scene.add_child(next_level_instance)

func show_game_over_screen():
	if game_over_instance:
		return
	game_over_instance = game_over_screen.instantiate()
	get_tree().current_scene.add_child(game_over_instance)

func show_stats():
	animation_player.play("Start")
