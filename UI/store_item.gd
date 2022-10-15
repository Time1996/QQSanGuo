extends TextureButton


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
	if get_node("TextureRect").texture == null or get_node("TextureRect").texture == data["origin_texture"]:
		get_node("TextureRect").texture = data["origin_texture"]
		get_node("Label").text = str(data["origin_quantity"])
		get_node("Label2").text = data["item_name"]
#		data["origin_path"].texture = null
		visible = true

func get_drag_data(position):
	var data = {}
	if get_node("TextureRect").texture != null:
		data["type"] = "player_store"
		data["origin_texture"] = get_node("TextureRect").texture
		data["origin_quantity"] = get_node("Label").text
		data["item_name"] = $Label2.text
		data["origin_path"] = get_node("TextureRect").get_path()
	else:
		data["origin_type"] = null
	return data
