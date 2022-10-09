extends Node2D

##物品数据脚本

var item_name
var item_quantity
var item_slot
var Tooltip = load("UI/ToolTip.tscn")
var userInterFace

func _ready():
#	var name_set = jsonData.item_data.keys()
#	item_name = name_set[int(randi()%name_set.size())]
#	print(item_name)
#	item_slot = get_parent().slot_index
	userInterFace = find_node("UserInterFace")
	$TextureRect.texture_normal = load("res://UI/item_icons/" + item_name + ".png")
	var stack_size = int(jsonData.item_data[item_name]["StackSize"])
#	item_quantity = randi() % stack_size + 1
	
	if item_quantity == 1:
		$Label.visible = false
	else:
		$Label.text = "X"+String(item_quantity)
	
func add_item_quantity(amount):
	item_quantity += amount
	$Label.text = "X"+String(item_quantity)

func sub_item_quantity(amount):
	item_quantity -= amount
	$Label.text = "X"+String(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture_normal = load("res://UI/item_icons/" + item_name + ".png")
	
	var stack_size = int(jsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = "X"+str(item_quantity)
	
	$Label3.text = item_name

func get_save_stats():
	item_slot = get_parent().slot_index
	print("save slot")
	print(item_slot)
	return {
		'filename' : get_filename(),
		'parent' : get_parent().get_path(),
		'data' : {
			'name' : item_name,
			'quantity' : item_quantity,
			'slot' : item_slot
		}
	}
#	var packed_scene = PackedScene.new()
#	packed_scene.pack(get_tree().get_current_scene())
#	ResourceSaver.save("res://ItemSaver.tscn", packed_scene)

func load_save_stats(stats):
	item_name = stats.data.name
	item_quantity = stats.data.quantity
	item_slot = stats.data.slot

func _on_TextureRect_mouse_entered():
	self.z_index = 99
	var tooltip = Tooltip.instance()
	add_child(tooltip)
	tooltip.rect_position = get_global_mouse_position()
	yield(get_tree().create_timer(0.35), "timeout")
	if has_node("ToolTip"):
		$ToolTip.assignment()
		$ToolTip.show()
#	$Label2.text = item_name
#	$Label2.visible = true
	pass # Replace with function body.


func _on_TextureRect_mouse_exited():
	self.z_index = 0
	$ToolTip.queue_free()
#	$Label2.visible = false
	pass # Replace with function body.


func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			use_item()
	pass # Replace with function body.

func use_item():
	if item_name == "神行之卷":
		find_parent("UserInterFace").get_parent().get_node("Steve").gain_speed()
	elif item_name == "通络丹":
		find_parent("UserInterFace").get_parent().get_node("Steve").gain_health(int(PlayerInventory.max_health/2))
	elif jsonData.item_data[item_name].ItemCategory == "Consumble": ##消耗品
		print(jsonData.item_data[item_name])
		find_parent("UserInterFace").get_parent().get_node("Steve").use_item(item_name)
	elif jsonData.item_data[item_name].ItemCategory == "Translation":
		if get_tree().get_root().has_node("bajun"):
			get_tree().get_root().get_node("bajun/Steve").position = Vector2(-16, -328)
		elif get_tree().get_root().has_node("Level1"):
			SceneChange.goto_scene("res://Scene/bajun.tscn", find_parent("Level1"))
		elif get_tree().get_root().has_node("JiangLinXiJiao"):
			SceneChange.goto_scene("res://Scene/bajun.tscn", find_parent("JiangLinXiJiao"))
			
	elif jsonData.item_data[item_name].ItemCategory == "Time":
		find_parent("UserInterFace").get_parent().get_node("Steve").gain_recover(300, 40)
		pass
	elif jsonData.item_data[item_name].ItemCategory == "Sword":
		exchange_equipment("Sword")
	elif jsonData.item_data[item_name].ItemCategory == "Up_Body":
		exchange_equipment("Up_Body")
	elif jsonData.item_data[item_name].ItemCategory == "Down_Body":
		exchange_equipment("Down_Body")
	elif jsonData.item_data[item_name].ItemCategory == "Hand":
		exchange_equipment("Hand")
	elif jsonData.item_data[item_name].ItemCategory == "Head":
		exchange_equipment("Head")
	elif jsonData.item_data[item_name].ItemCategory == "Boot":
		exchange_equipment("Boot")
	elif jsonData.item_data[item_name].ItemCategory == "Wing":
		exchange_equipment("Wing")
	elif jsonData.item_data[item_name].ItemCategory == "Ring":
		exchange_equipment("Ring")
	elif jsonData.item_data[item_name].ItemCategory == "Necklace":
		exchange_equipment("Necklace")
	var index = get_parent().slot_index
	
	if (jsonData.item_data[item_name].ItemCategory == "Time"
		or 
		jsonData.item_data[item_name].ItemCategory == "Consumble"
		or
		jsonData.item_data[item_name].ItemCategory == "Translation"):
			
		PlayerInventory.inventory[index][1] -= 1
		
		PlayerInventory.update_slot_visual(index, 
										PlayerInventory.inventory[index][0], 
										PlayerInventory.inventory[index][1]
		)
		if item_quantity == 0:
			remove_inventory_item()

func remove_inventory_item():
	userInterFace.holding_item = null
	get_parent().item = null
	PlayerInventory.remove_item(get_parent())
	queue_free()

func exchange_equipment(catagory):
	var temp = find_parent("Inventory").get_node("equipment").get_node(catagory).item_name
	if find_parent("Inventory").get_node("equipment").get_node(catagory).texture_normal != null:
		find_parent("Inventory").get_node("equipment").get_node(catagory).texture_normal = self.get_node("TextureRect").texture_normal
		find_parent("Inventory").get_node("equipment").get_node(catagory).item_name = self.item_name
		print(temp)
		print(self.item_name)
		PlayerInventory.update_put_on(item_name)
		PlayerInventory.update_put_off(temp)
		self.set_item(temp, 1)
		#交换图片即可
	else:
		find_parent("Inventory").get_node("equipment").get_node(catagory).texture_normal = self.get_node("TextureRect").texture_normal
		find_parent("Inventory").get_node("equipment").get_node(catagory).item_name = self.item_name
		PlayerInventory.update_put_on(item_name)
		remove_inventory_item()
	
	
	userInterFace.update_text(PlayerInventory.level, PlayerInventory.max_health, PlayerInventory.max_magic,
		PlayerInventory.basic_damage, PlayerInventory.basic_defende,
		PlayerInventory.basic_shugong, PlayerInventory.basic_shufang,
		PlayerInventory.force, PlayerInventory.agility,
		PlayerInventory.wisdom, PlayerInventory.strong,
		PlayerInventory.aim
	)
