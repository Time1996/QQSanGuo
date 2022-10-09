extends Control

var drag_position = null

func _ready():
	pass


func _on_TextureButton7_pressed():
	self.visible = !self.visible
	pass # Replace with function body.


func _on_TextureButton5_pressed():
	self.visible = !self.visible
	pass # Replace with function body.


func _on_TextureButton_pressed():
	$current_task.visible = true
	$main_task.visible = false
	$remain_task.visible = false
	pass # Replace with function body.


func _on_TextureButton2_pressed():
	$current_task.visible = false
	$main_task.visible = true
	$remain_task.visible = false
	pass # Replace with function body.


func _on_TextureButton3_pressed():
	$current_task.visible = false
	$main_task.visible = false
	$remain_task.visible = true
	pass # Replace with function body.


func _on_current_task_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
			
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
	pass # Replace with function body.
