extends TextureButton

var item_name = null

func _ready():
	pass
	
func get_drag_data(position):
	var data = {}
	data["origin_texture"] = self.texture_normal

	data["origin_item_quantity"] = 1
	data["slot_type"] = "equipment"
	data["origin_path"] = get_path()
	print(get_path())
	
	var temp_str = str(self.texture_normal.get_path())
	var regex = RegEx.new()
	regex.compile("[\u4e00-\u9fa5]") #只匹配中文
	var result = regex.search_all(temp_str)
	temp_str = ""
	for i in result:
		temp_str += i.get_string()
	
	data["origin_item_name"] = temp_str #帖图的名字 就是物品名
	
#	data["slot_index"] = get_parent().get_parent().slot_index
#	print("slot_index", data["slot_index"])

	var drag_texture = TextureRect.new()
	drag_texture.texture = self.texture_normal
	drag_texture.rect_size = self.rect_size
	
	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	
	set_drag_preview(control)
	return data
	
func can_drop_data(position, data):
	if data["slot_type"] == "inventory":
		if self.texture_normal == null and data["equipment"] == self.name:
			return true
	return false

func drop_data(position, data):
	self.texture_normal = data["origin_texture"]
	self.item_name = data["origin_item_name"]
	#删掉包里的
	PlayerInventory.inventory.erase(data["slot_index"])
	print(data["origin_path"])
	get_tree().get_root().get_node(data["origin_path"]).get_parent().item = null
	get_tree().get_root().get_node(data["origin_path"]).queue_free()
	
	print(data["origin_item_name"])
	PlayerInventory.update_put_on(data["origin_item_name"])
	
	find_parent("UserInterFace").update_text(PlayerInventory.level, PlayerInventory.max_health, PlayerInventory.max_magic,
											 PlayerInventory.basic_damage, PlayerInventory.basic_defende,
											 PlayerInventory.basic_shugong, PlayerInventory.basic_shufang,
											PlayerInventory.force, PlayerInventory.agility,
											PlayerInventory.wisdom, PlayerInventory.strong,
											PlayerInventory.aim
	)
	return
#	PlayerInventory.update_slot_visual(data["slot_index"], drag["item_name"], drag_item.item_quantity)
