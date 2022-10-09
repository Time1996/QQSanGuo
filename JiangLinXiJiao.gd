extends Node2D


func _ready():
	pass



func _on_TransPort_body_entered(body):
	SceneChange.goto_scene("res://Level1.tscn", self)
#	get_tree().change_scene("res://Level1.tscn")
	pass # Replace with function body.
