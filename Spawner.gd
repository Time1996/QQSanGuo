extends Node2D

signal monster_die

var eneme_set = preload("res://Enemy//Snake.tscn")


func _ready():
	monster_generation(10)
	pass

func monster_generation(num):
	yield(get_tree(), "idle_frame")
	
	for i in range(1, num+1):
		var e1 = eneme_set.instance()
		var s ="2_"+str(i)
		e1.position = get_node(s).position
		e1.add_to_group("enemy")
		e1.set_collision_layer_bit(1,1)
		e1.set_collision_layer_bit(0,0)
		e1.set_collision_mask_bit(0,0)
		e1.connect("monster_die", self, "_on_Spawner_monster_die")
		get_node("/root/Level1").add_child(e1)
		$Tween.interpolate_property(e1, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1,Tween.TRANS_LINEAR)
		
		$Tween.start()
		yield($Tween,"tween_completed")

func respawn():
	monster_generation((randi()%3)+1)


func _on_Spawner_monster_die():
	get_node("../Steve").gain_money(100, 1)
	get_node("../Steve").gain_experience(1)
	pass # Replace with function body.
