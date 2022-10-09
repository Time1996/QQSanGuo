extends Control

var textureRect = TextureRect.new()
var label_name = Label.new()
var label_description = Label.new()
var label_property = Label.new()
var label_slot = Label.new()
var label_job = Label.new()
var label_duration = Label.new()

#func _ready():
#	for i in $VBoxContainer.get_children():
#		i.rect_size = Vector2(0, 0)
#	pass

func assignment():
	
	textureRect.texture = get_parent().get_node("TextureRect").texture_normal
	label_name.text = get_parent().item_name
	label_description.text = jsonData.item_data[get_parent().item_name].Description
	
	if jsonData.item_data[get_parent().item_name].WuGong != null:
		label_property.text += "物攻 +" + str(jsonData.item_data[get_parent().item_name].WuGong) + "\n"
	if jsonData.item_data[get_parent().item_name].WuGong != null:
		label_property.text += "物防 +" + str(jsonData.item_data[get_parent().item_name].WuFang) + "\n"
	if jsonData.item_data[get_parent().item_name].WuGong != null:
		label_property.text += "术攻 +" + str(jsonData.item_data[get_parent().item_name].ShuGong) + "\n"
	if jsonData.item_data[get_parent().item_name].WuGong != null:
		label_property.text += "术防 +" + str(jsonData.item_data[get_parent().item_name].ShuFang) + "\n"
	if jsonData.item_data[get_parent().item_name].Slot != null:
		label_slot.text = "可以打孔 X"+ str(jsonData.item_data[get_parent().item_name].Slot)
	if jsonData.item_data[get_parent().item_name].Job != null:
		label_job.text = "适用职业[" + str(jsonData.item_data[get_parent().item_name].Job) + "]"
	if jsonData.item_data[get_parent().item_name].Duration != null:
		label_duration.text = "耐久度: " + str(jsonData.item_data[get_parent().item_name].Duration)
	if textureRect.texture != null:
		$VBoxContainer.add_child(textureRect)
	if label_name.text != "":
		$VBoxContainer.add_child(label_name)
	if label_description.text != "":
		$VBoxContainer.add_child(label_description)
	if label_property.text != "":
		$VBoxContainer.add_child(label_property)
	if label_slot.text != "":
		label_slot.set("custom_colors/font_color", Color.green)
		$VBoxContainer.add_child(label_slot)
	if label_job.text != "":
		$VBoxContainer.add_child(label_job)
	if label_duration.text != "":
		$VBoxContainer.add_child(label_duration)
