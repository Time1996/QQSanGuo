extends ScrollContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func can_drop_data(position, data):
	if data["type"] == "player_pack":
		return true

func drop_data(position, data):
#	print(data)
	for i in $items.get_children():
		if i.get_node("TextureRect").texture == null or i.get_node("TextureRect").texture == data["origin_texture"]:
			i.get_node("TextureRect").texture = data["origin_texture"]
			i.get_node("Label").text = str(data["origin_quantity"])
			i.get_node("Label2").text = data["item_name"]
			i.visible = true
			break



func _on_Area2D_mouse_entered():
	print("mouse in area")
