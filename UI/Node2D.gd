extends Node2D

var last_mouse_position
onready var pm = $PopupMenu

func _ready():
	pm.add_item("使用", 0)
	pm.add_item("丢弃", 1)
	pm.add_item("销毁", 2)
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT:
		last_mouse_position = get_global_mouse_position()
		pm.popup(Rect2(last_mouse_position.x, last_mouse_position.y, pm.rect_size.x, pm.rect_size.y))


func _on_PopupMenu_id_pressed(id):
	if id == 0:
		print("使用")
	if id == 1:
		print("丢弃")
	if id == 2:
		print("销毁")
	pass # Replace with function body.
