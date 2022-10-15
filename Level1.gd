extends Node2D

var load_scene

func _ready():
	pass





func _on_TransPort_body_entered(body):
#	load_scene = load("res://JiangLinXiJiao.tscn")
#	SceneChange.goto_scene("res://JiangLinXiJiao.tscn", self)
	get_tree().change_scene("res://JiangLinXiJiao.tscn")
	pass # Replace with function body.

#
#func _on_Timer_timeout():#auto generation
#	var nodes = get_tree().get_nodes_in_group("enemy").size()
#	if nodes < 10:
#		$Spawner_Snake.monster_generation(10-nodes)
#	pass # Replace with function body.


func _on_TransPort2_body_entered(body):
#	load_scene = load("res://Scene/bajun.tscn")
#	SceneChange.goto_scene("res://bajun.tscn", self)
	get_tree().change_scene("res://Scene/bajun.tscn")
	pass # Replace with function body.

func _exit_tree():
#	load_scene.free()
	pass
