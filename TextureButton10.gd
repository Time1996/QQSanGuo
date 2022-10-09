extends TextureButton

func get_drag_data(position):
	print(position,"drag")
	if has_node("TextureRect"):
		var texture = TextureButton.new()
		texture.texture_normal = $TextureRect.texture
		texture.rect_scale = $TextureRect.rect_scale
		set_drag_preview(texture)
		return $TextureRect
	return false
	
func can_drop_data(position, data):
	return true

func drop_data(position, data):
	print("drop",position,data)
	if data and get_child_count()==0:
		self.add_child(data.duplicate())
		data.queue_free()
