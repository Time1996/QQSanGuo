extends Control

##快捷栏

const SlotClass = preload("res://Slot.gd")
onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()
onready var active_item_label = $ActiveItemLabel

func _ready():
	#var slots = inventory_slots.get_children()
	PlayerInventory.connect("active_item_updated", self, "update_active_item_label")
	for i in range(slots.size()): ##每个子节点都连上 函数
		slots[i].slot_index = i
		PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_type = SlotClass.SlotType.HOTBAR
		
	initialize_hotbar()
	update_active_item_label()

func update_active_item_label(): ##物品信息 左上角文字显示
	if slots[PlayerInventory.active_item_slot].item != null:
		active_item_label.text = slots[PlayerInventory.active_item_slot].item.item_name
	else:
		active_item_label.text = ""
func initialize_hotbar():
	#var slots = inventory_slots.get_children()
	#print("数量",slots.size())
	for i in range(slots.size()): ##每个子节点都连上 函数
		if PlayerInventory.hotbar.has(i): ##initialize_item函数 有BUG 
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if find_parent("UserInterFace").holding_item != null:
				if !slot.item: ##空的 直接放进去
					left_click_empty_slot(slot)
				else: ##不空 先把有的存在变量里跟随鼠标 然后拿着的放进去之后 把拿着的变成本来在框里的
					if find_parent("UserInterFace").holding_item != slot.item: ## 如果不是同种物品
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item: ##已经有了 就把东西拿出来 并且跟随鼠标位置
				left_click_not_holding(slot)
			update_active_item_label()
				
func _input(event):
	if find_parent("UserInterFace").holding_item:
		find_parent("UserInterFace").holding_item.global_position = get_global_mouse_position()

func left_click_empty_slot(slot):
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterFace").holding_item, slot, true)
	slot.putIntoSlot(find_parent("UserInterFace").holding_item)
	find_parent("UserInterFace").holding_item = null
	
func left_click_different_item(event, slot):
	PlayerInventory.remove_item(slot, true)
	PlayerInventory.add_item_to_empty_slot(find_parent("UserInterFace").holding_item, slot, true)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("UserInterFace").holding_item)
	find_parent("UserInterFace").holding_item = temp_item
	
func left_click_same_item(slot):
	var stack_size = int(jsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity 
	if able_to_add >= find_parent("UserInterFace").holding_item.item_quantity: ##可以合并
		PlayerInventory.add_item_quantity(slot, find_parent("UserInterFace").holding_item.item_quantity, true)
		slot.item.add_item_quantity(find_parent("UserInterFace").holding_item.item_quantity)
		find_parent("UserInterFace").holding_item.queue_free()
		find_parent("UserInterFace").holding_item = null
	else: ##不可以合并
		if able_to_add == 0:
			left_click_different_item(find_parent("UserInterFace").holding_item, slot)
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add, true)
			slot.item.add_item_quantity(able_to_add) ##放的地方加
			find_parent("UserInterFace").holding_item.sub_item_quantity(able_to_add) ##手里拿的减

func left_click_not_holding(slot):
	PlayerInventory.remove_item(slot, true)
	find_parent("UserInterFace").holding_item = slot.item
	slot.pickFromSlot()
	find_parent("UserInterFace").holding_item.global_position = get_global_mouse_position()




