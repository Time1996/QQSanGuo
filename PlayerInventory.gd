extends Node


const NUM_INVENTORY_SLOTS = 50
const NUM_HOTBAR_SLOTS = 8

var money = 0
var juntuan = 0
var max_health = 1000
var max_magic = 1000
var basic_damage = 20
var basic_defende = 10
var basic_shugong = 0
var basic_shufang = 0
var force = 0
var agility = 0
var strong = 0
var wisdom = 0
var aim = 0
var level = 1



##背包初始内容
var inventory = {
	0 : ["回城符", 2],
	1 : ["铁剑", 1],
	2 : ["紫金剑", 1],
	3 : ["红红肉", 5]
#	0 : ["金疮药", 99]
}

var hotbar = {
#	0 : ["金疮药", 99]
}

var active_item_slot = 0

func add_item(item_name, item_quantity):
	for i in inventory:
		if inventory[i][0] == item_name:
			var stack_size = int(jsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[i][1]
			if able_to_add >= item_quantity:
				inventory[i][1] += item_quantity
				update_slot_visual(i, inventory[i][0], inventory[i][1])  ##更新下当前格子状态
				return
			else:
				inventory[i][1] += able_to_add	##还有剩下的去找空格子
				update_slot_visual(i, inventory[i][0], inventory[i][1])  ##更新下当前格子状态
				item_quantity -= able_to_add

	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return
			

func _ready():
	pass

func add_item_to_empty_slot(item, slot, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
	else:
		inventory[slot.slot_index] = [item.item_name, item.item_quantity]
	
func remove_item(slot, is_hotbar: bool = false):
	if is_hotbar:
		hotbar.erase(slot.slot_index)
	else:
		inventory.erase(slot.slot_index)
	
func add_item_quantity(slot, quantity_to_add, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.slot_index][1] += quantity_to_add
	else:
		inventory[slot.slot_index][1] += quantity_to_add
		if inventory[slot.slot_index][1] <= 0:
			print("从inventory删除次物品")
			inventory.erase(slot.slot_index)

func update_slot_visual(slot_index, item_name, new_quantity):
	var slot
	if get_tree().get_root().has_node("Level1"):
		slot = get_tree().get_root().get_node("Level1/UserInterFace/Inventory/ScrollContainer/VBoxContainer/Panel" + str(slot_index + 1))
	elif get_tree().get_root().has_node("bajun"):
		slot = get_tree().get_root().get_node("bajun/UserInterFace/Inventory/ScrollContainer/VBoxContainer/Panel" + str(slot_index + 1))
	elif get_tree().get_root().has_node("JiangLinXiJiao"):
		slot = get_tree().get_root().get_node("JiangLinXiJiao/UserInterFace/Inventory/ScrollContainer/VBoxContainer/Panel" + str(slot_index + 1))
	
	if slot.item != null and slot.get_child_count() > 0:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func update_put_on(new_name):
	var temp_item = jsonData.item_data[new_name]
	add_property(temp_item)

func update_put_off(new_name):
	var temp_item = jsonData.item_data[new_name]
	sub_property(temp_item)

func sub_property(temp_item):
	if temp_item.WuGong != null:
		basic_damage -= int(temp_item.WuGong)
	if temp_item.ShuGong != null:
		basic_shugong -= int(temp_item.ShuGong)
	if temp_item.Force != null:
		force -= int(temp_item.Force)
	if temp_item.Agility != null:
		agility -= int(temp_item.Agility)
	if temp_item.Strong != null:
		strong -= int(temp_item.Strong)
	if temp_item.Wisdom != null:
		wisdom -= int(temp_item.Wisdom)
	if temp_item.Aim != null:
		aim -= int(temp_item.Aim)
	if temp_item.WuFang != null:
		basic_defende -= int(temp_item.WuFang)
	if temp_item.ShuFang != null:
		basic_shufang -= int(temp_item.ShuFang)
	if temp_item.HP != null:
		max_health -= int(temp_item.HP)
	if temp_item.Mana != null:
		max_magic -= int(temp_item.Mana)

func add_property(temp_item):
	if temp_item.WuGong != null:
		basic_damage += int(temp_item.WuGong)
	if temp_item.ShuGong != null:
		basic_shugong += int(temp_item.ShuGong)
	if temp_item.Force != null:
		force += int(temp_item.Force)
	if temp_item.Agility != null:
		agility += int(temp_item.Agility)
	if temp_item.Strong != null:
		strong += int(temp_item.Strong)
	if temp_item.Wisdom != null:
		wisdom += int(temp_item.Wisdom)
	if temp_item.Aim != null:
		aim += int(temp_item.Aim)
	if temp_item.WuFang != null:
		basic_defende += int(temp_item.WuFang)
	if temp_item.ShuFang != null:
		basic_shufang += int(temp_item.ShuFang)
	if temp_item.HP != null:
		max_health += int(temp_item.HP)
	if temp_item.Mana != null:
		max_magic += int(temp_item.Mana)

func remove_all_item():
	print("clear")
	hotbar.clear()
	inventory.clear()
