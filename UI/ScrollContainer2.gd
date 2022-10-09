extends ScrollContainer

var money

func _ready():
	money = 0
	pass

func can_drop_data(position, data):
	return true

func drop_data(position, data):
	
	if data["origin_type"] == "sell": #卖东西
		get_tree().get_root().get_node(data["origin_path"]).mouse_filter = MOUSE_FILTER_IGNORE
		for i in get_node("VBoxContainer").get_children():
			if i.get_node("TextureRect").texture == null:
				i.get_node("TextureRect").texture = data["origin_texture"]
				i.get_node("Label").text = data["origin_quantity"]
				i.get_node("Label2").text = data["item_name"]
				i.price = int(data["origin_price"])
				i.visible = true
				money += data["origin_price"] * int(i.get_node("Label").text.substr(1))
				get_parent().get_node("Label5").text = "+" + str(money)
				break
	else:
		get_parent().get_node("TextureRect/WindowDialog").visible = true
		var quantity = int(get_parent().get_node("TextureRect/WindowDialog/OptionButton").get_selected_id())
		for i in get_node("VBoxContainer").get_children():
			if i.get_node("TextureRect").texture == null:
				i.get_node("TextureRect").texture = data["origin_texture"]
				i.get_node("Label2").text = str(data["item_name"])
				i.get_node("Label").text = str(quantity)
				i.price = int(data["origin_price"])
				i.visible = true
				money -= data["origin_price"] * quantity
				if PlayerInventory.money + money < 0: ##因为money是负数所以用加
					get_parent().get_node("TextureRect/AcceptDialog").visible = true
					return
				get_parent().get_node("Label5").text = str(money)
				break
