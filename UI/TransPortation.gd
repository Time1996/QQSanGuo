extends CanvasLayer


func _ready():
	pass # Replace with function body.



func _on_Button_pressed():
	var bajun = find_parent("bajun")
#	SceneChange.goto_scene("res://JiangLinXiJiao", bajun)
	get_tree().change_scene("res://JiangLinXiJiao.tscn")


func _on_Button1_pressed():
	visible = false
