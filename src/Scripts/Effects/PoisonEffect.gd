class_name PoisonEffect
extends Effect

var poison_timer = preload("res://src/Scenes/PoisonTimer.tscn")

func give_effect():
	var instance : PoisonTimer = poison_timer.instantiate()
	instance.take_damage.connect(Global.player.grow)
	Global.player.add_child(instance)
