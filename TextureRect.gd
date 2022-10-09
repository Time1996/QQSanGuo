extends TextureButton


func get_drag_data(position):
	var data = {}
	data["origin_path"] = get_parent().get_path()
	data["origin_texture"] = self.texture_normal
	data["origin_item_name"] = get_parent().item_name
	data["origin_item_quantity"] = get_parent().item_quantity
	data["slot_index"] = get_parent().get_parent().slot_index
	data["slot_type"] = "inventory"
	data["equipment"] = jsonData.item_data[get_parent().item_name].ItemCategory
	var drag_texture = TextureRect.new()
	drag_texture.texture = self.texture_normal
	drag_texture.rect_size = self.rect_size
	
	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	
	set_drag_preview(control)
	return data
