extends Control

##库存系统

const SlotClass = preload("res://Slot.gd")
onready var inventory_slots = $ScrollContainer/VBoxContainer

var drag_position = null

func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()): ##每个子节点都连上 函数
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]]) #捕获每次gui_input信号 对于每次捕捉到的信号 进行处理slot_gui_input函数 传递的参数是[slots[i]
		slots[i].slot_index = i
		slots[i].slot_type = SlotClass.SlotType.INVENTORY
	initialize_inventory()


func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UserInterFace").holding_item != null:
				if !slot.item: ##空的 直接放进去
					left_click_empty_slot(slot)
				else: ##不空 先把有的存在变量里跟随鼠标 然后拿着的放进去之后 把拿着的变成本来在框里的
					if slot.get_child_count() > 0 :
						if find_parent("UserInterFace").holding_item.item_name != slot.item.item_name: ## 如果不是同种物品
							left_click_different_item(event, slot)
						else:
							left_click_same_item(slot)
			elif slot.item: ##已经有了 就把东西拿出来 并且跟随鼠标位置
				left_click_not_holding(slot)
				
func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()): ##每个子节点都连上 函数
		if PlayerInventory.inventory.has(i): ##initialize_item函数 有BUG 
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
		
func _input(event):
	if find_parent("UserInterFace").holding_item:
		find_parent("UserInterFace").holding_item.global_position = get_global_mouse_position()

func left_click_empty_slot(slot):
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterFace").holding_item, slot)
	slot.putIntoSlot(find_parent("UserInterFace").holding_item)
	find_parent("UserInterFace").holding_item = null
	
func left_click_different_item(event, slot):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterFace").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterFace").holding_item)
	find_parent("UserInterFace").holding_item = temp_item
	
func left_click_same_item(slot):
	var stack_size = int(jsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= find_parent("UserInterFace").holding_item.item_quantity: ##可以合并
		PlayerInventory.add_item_quantity(slot, find_parent("UserInterFace").holding_item.item_quantity)
		slot.item.add_item_quantity(find_parent("UserInterFace").holding_item.item_quantity)
		find_parent("UserInterFace").holding_item.queue_free()
		find_parent("UserInterFace").holding_item = null
	else: ##不可以合并
		if able_to_add == 0:
			left_click_different_item(find_parent("UserInterFace").holding_item, slot)
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add) ##放的地方加
			find_parent("UserInterFace").holding_item.sub_item_quantity(able_to_add) ##手里拿的减

func left_click_not_holding(slot):
	if slot.get_child_count() > 0:
		PlayerInventory.remove_item(slot)
		find_parent("UserInterFace").holding_item = slot.item
		slot.pickFromSlot()
		find_parent("UserInterFace").holding_item.global_position = get_global_mouse_position()


func _on_TextureButton_pressed():
	self.visible = !self.visible
	pass # Replace with function body.




func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
			
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
	pass # Replace with function body.
