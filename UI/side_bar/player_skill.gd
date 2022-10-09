extends Control

var drag_position = null

func _ready():
	pass


func _on_TextureButton2_pressed():
	self.visible = !self.visible
	pass # Replace with function body.


func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
			
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
	pass # Replace with function body.
