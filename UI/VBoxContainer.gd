extends VBoxContainer


func _ready():
	for i in get_children():
		i.visible = false
	pass

func get_drag_data(position):
	var data = {}
	return data


