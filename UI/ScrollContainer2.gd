extends ScrollContainer

var money

func _ready():
	money = 0
	pass
	
var data1
func can_drop_data(position, data):
	data1 = data
#	print(data)
	return true

var quantity = 1

func sell(data):
	get_parent().get_node("HScrollBar").max_value = int(data["origin_quantity"])
	get_parent().get_node("HScrollBar").visible = true
	get_tree().get_root().get_node(data["origin_path"]).mouse_filter = MOUSE_FILTER_IGNORE
	for i in get_node("VBoxContainer").get_children():
		if i.get_node("TextureRect").texture == null or i.get_node("TextureRect").texture == data["origin_texture"]:
			i.get_node("TextureRect").texture = data["origin_texture"]
			i.get_node("Label").text = str(quantity)
			i.get_node("Label2").text = data["item_name"]
			i.price = int(data["origin_price"])
			i.visible = true
			money = data["origin_price"] * quantity
#					get_parent().get_node("Label5").font_color = Color.green
			get_parent().get_node("Label5").text = "+" + str(money)
			break

func buy(data):
	get_parent().get_node("HScrollBar").max_value = int(PlayerInventory.money / data["origin_price"]) ##money除以物品价格
	print("最大数量", get_parent().get_node("HScrollBar").max_value)
	
	get_parent().get_node("HScrollBar").visible = true
	get_tree().get_root().get_node(data["origin_path"]).mouse_filter = MOUSE_FILTER_IGNORE
	for i in get_node("VBoxContainer").get_children():
		if i.get_node("TextureRect").texture == null or i.get_node("TextureRect").texture == data["origin_texture"]:
			i.get_node("TextureRect").texture = data["origin_texture"]
			i.get_node("Label2").text = str(data["item_name"])
			i.get_node("Label").text = str(quantity)
			i.price = int(data["origin_price"])
			i.visible = true
			money = -(data["origin_price"] * quantity)
			if PlayerInventory.money + money < 0: ##因为money是负数所以用加
#				get_parent().get_node("TextureRect/AcceptDialog").visible = true
				get_parent().refresh()##刷新页面
				get_parent().pack_refresh()##重新打开页面
#					get_parent().get_node("Label5").font_color = Color.red
			get_parent().get_node("Label5").text = str(money)
			break
	
func drop_data(position, data):
	if data["origin_type"]:
		if data["origin_type"] == "sell":#卖东西
			sell(data)
		else:
			buy(data)
	find_parent("UserInterFace").update_inventory(PlayerInventory.money, PlayerInventory.juntuan)


func _on_HScrollBar_value_changed(value):
	quantity = value
	if data1["origin_type"] == "sell":#卖东西
		sell(data1)
	else:
		buy(data1)
