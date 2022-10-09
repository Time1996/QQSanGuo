extends Panel


func _ready():
	pass

func _process(delta):
	self.rect_size = get_parent().get_node("VBoxContainer").rect_size
