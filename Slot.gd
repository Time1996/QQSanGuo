extends Panel

var default_style = null
var selected_style = null

var default_tex = preload("res://UI/player_inventory/main/67445-1.png")
var selected_tex = preload("res://UI/player_inventory/main/67445-2.png")
var drag_item = preload("res://Item.tscn").instance()

var item = null
var ItemClass = preload("res://Item.tscn")
var slot_index
var slot_type

var last_mouse_position
onready var pm = $PopupMenu

enum SlotType{#第一个设置0 后面的自动递增+1
	HOTBAR = 0,
	INVENTORY,
}
func _ready():
	pm.add_item("使用", 0)
	pm.add_item("丢弃", 1)
	pm.add_item("销毁", 2)
	slot_index = int(self.name.substr(self.name.length()-1, 1))
	selected_style = StyleBoxTexture.new()
	default_style = StyleBoxTexture.new()
	
	default_style.texture = default_tex
	selected_style.texture = selected_tex
	
	var nodes = get_parent()
	self.connect("gui_input", self, "gui")
	self.connect("mouse_entered", self, "mouse_enter")
	self.connect("mouse_exited", self, "mouse_exit")
#	for i in nodes.get_children(): ## 这串代码会卡 不知道为什么
#		i.connect("mouse_entered", i, "mouse_enter")
#		i.connect("mouse_exited", i, "mouse_exit")
#		i.connect("gui_input", i, "gui")
#		i.get_node("PopupMenu").connect("id_pressed", i, "_on_PopupMenu_id_pressed")
	
	refresh_style()
#	styleBox.texture = preload("res://UI/21804-1.png")
#	self.hint_tooltip = "111"
	pass

func delete_item():
	item = null
	get_node("Item").queue_free()
	PlayerInventory.inventory.erase(slot_index)

func gui(event):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_RIGHT:
		last_mouse_position = get_global_mouse_position()
		pm.popup(Rect2(last_mouse_position.x, last_mouse_position.y, pm.rect_size.x, pm.rect_size.y))

func refresh_style():
	yield(get_tree(),"idle_frame")
	set('custom_styles/panel', default_style)
	

func pickFromSlot():
	print("pickFromSlot")
	if self.get_child_count() > 0:
		remove_child(item)
		FreeNodes.free_orphaned_nodes()
		var inventoryNode = find_parent("UserInterFace")
		inventoryNode.add_child(item)
		item.get_node("TextureRect").mouse_filter = MOUSE_FILTER_IGNORE
		item = null

func putIntoSlot(new_item):
	print(new_item)
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("UserInterFace")
	inventoryNode.remove_child(item)
	FreeNodes.free_orphaned_nodes()
	add_child(item)
	item.get_node("TextureRect").mouse_filter = MOUSE_FILTER_STOP
	#refresh_style() ##暂时不用 用了之后会导致放下后 大小不对

func initialize_item(item_name, item_quantity):
	if item == null:##有BUG 每次重新打开会
		item = ItemClass.instance()
		item.scale *= 0.75
		item.set_item(item_name, item_quantity)
		add_child(item)
	else:
		item.set_item(item_name, item_quantity)
		

#func _input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_RIGHT && event.pressed:
#			get_parent().get_parent().get_parent().get_node("PopupMenu").popup(
#				get_global_mouse_position().x, get_global_mouse_position().y,
#				110, 110
#			)
	
func _make_custom_tooltip(for_text):
	var label = Label.new()
	var goods_data = "123"	# 物品数据
	#label.text = print(goods_data, '\t')
	return label


func mouse_enter():
	set('custom_styles/panel', selected_style)
	pass # Replace with function body.


func mouse_exit():
	set('custom_styles/panel', default_style)
	pass # Replace with function body.

func can_drop_data(position, data):
	if self.get_child_count() == 0:
		return true
	else:
		return false
	
func drop_data(position, data):
	drag_item.get_node("TextureRect").texture_normal = data["origin_texture"]
	drag_item.set_item(data["origin_item_name"], data["origin_item_quantity"])
	drag_item.scale *= 0.75

#	PlayerInventory.add_item(drag_item.item_name, 1)
	PlayerInventory.add_item_to_empty_slot(drag_item, self)
#	PlayerInventory.update_slot_visual(slot_index, drag_item.item_name, drag_item.item_quantity)
#	add_child(drag_item) 
	drag_item.get_node("TextureRect").mouse_filter = MOUSE_FILTER_STOP
#	if data["slot_type"] == "inventory":
#		for i in get_parent().get_children():
#			if i.slot_index == data["slot_index"]:
#				print(i.slot_index, data["slot_index"])
#				i.remove_child(i.get_child(0))
##				PlayerInventory.update_slot_visual(i.slot_index, drag_item.item_name, drag_item.item_quantity)
#				break
#		PlayerInventory.inventory.erase(data["slot_index"])

	PlayerInventory.update_slot_visual(slot_index, drag_item.item_name, drag_item.item_quantity)
	if data["slot_type"] == "equipment":
		get_tree().get_root().get_node(data["origin_path"]).texture_normal = null
		PlayerInventory.update_put_off(data["origin_item_name"])
	elif data["slot_type"] == "inventory":
		get_tree().get_root().get_node(data["origin_path"]).get_parent().item = null
		get_tree().get_root().get_node(data["origin_path"]).queue_free()
	
	find_parent("UserInterFace").update_text(PlayerInventory.level, PlayerInventory.max_health, PlayerInventory.max_magic,
											 PlayerInventory.basic_damage, PlayerInventory.basic_defende,
											 PlayerInventory.basic_shugong, PlayerInventory.basic_shufang,
											PlayerInventory.force, PlayerInventory.agility,
											PlayerInventory.wisdom, PlayerInventory.strong,
											PlayerInventory.aim
	)
#	data["slot"].remove_child(data["item"])
#	remove_child(0)
	pass




func _on_PopupMenu_id_pressed(id):
	if id == 0:
		if has_node("Item"):
			get_node("Item").use_item()
	if id == 1:
		print("丢弃")
	if id == 2:
		if has_node("Item"):
			delete_item()
		print("销毁")
	pass # Replace with function body.
