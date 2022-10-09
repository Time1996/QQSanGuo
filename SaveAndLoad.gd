extends Control


func _ready():
	pass


func _on_Button_pressed():
	SaveState.save_game()
	print("save")
	pass # Replace with function body.


func _on_Button2_pressed():
	SaveState.load_game()
	print("load")
	pass # Replace with function body.


func _on_Button3_pressed():
	self.visible = false
	pass # Replace with function body.


func _on_Button4_pressed():
	$CenterContainer/Button4/AcceptDialog.popup_centered()
	pass # Replace with function body.


func _on_AcceptDialog_confirmed():
#	SceneChange.goto_scene("res://Login.tscn", self)
	get_tree().change_scene("res://Login.tscn")
	pass # Replace with function body.


func _on_AcceptDialog_mouse_entered():
	print("Mouse be absorbd in there")
	pass # Replace with function body.
