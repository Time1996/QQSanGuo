extends Control

var drag_position = null

onready var backpack = get_parent().get_node("Inventory/ScrollContainer")

func _ready():
#	add_child(backpack)
	self.visible = false
	pass

func refresh():
	print("refresh")
	print(PlayerInventory.inventory.size())
	print(str(PlayerInventory.money))
#	$Label.text = str(PlayerInventory.juntuan)
#	$Label2.text = str(PlayerInventory.money)
	$Label3.text = str(PlayerInventory.inventory.size()) + "+" + str(PlayerInventory.NUM_INVENTORY_SLOTS)
	clear_pack()
	
	var a = 0
	var b = 0
	for i in $ScrollContainer/VBoxContainer.get_children():
		b = 0
		for j in PlayerInventory.NUM_INVENTORY_SLOTS:
			if a==b:
				if PlayerInventory.inventory.has(j):
					i.get_child(0).texture = load("res://UI/item_icons/"+PlayerInventory.inventory[j][0]+".png")
					i.get_child(1).text = "X"+str(PlayerInventory.inventory[j][1])
					i.get_child(2).text = str(PlayerInventory.inventory[j][0])
					break
				else:
					i.get_child(0).texture = null
					i.get_child(1).text = ""
					i.get_child(2).text = ""
			b += 1
		a += 1
	
func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
			
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
	pass # Replace with function body.


func _on_TextureButton6_pressed():
	self.visible = false
	pass # Replace with function body.


func clear_pack():
	get_node("ScrollContainer2").money = 0
	get_node("Label5").text = ""
	for i in $ScrollContainer/VBoxContainer.get_children():
		i.mouse_filter = MOUSE_FILTER_STOP
	for i in $ScrollContainer2/VBoxContainer.get_children():
		i.get_node("TextureRect").texture = null
		i.get_node("Label").text = ""
#		i.price = 0
		i.visible = false

func _on_TextureButton4_pressed():
	clear_pack()
	pass # Replace with function body.


func _on_TextureButton5_pressed():
	var userInterFace = find_parent("UserInterFace")
	if $ScrollContainer.visible == true: #卖的界面
		for i in userInterFace.get_node("Inventory/ScrollContainer/VBoxContainer").get_children():
			for j in get_node("ScrollContainer2/VBoxContainer").get_children():
				if i.get_child_count() > 1:##因为自带一个PopupMenu
					if i.get_node("Item/TextureRect").texture_normal == j.get_node("TextureRect").texture:
						i.delete_item()
						break
	else:
		for i in $ScrollContainer2/VBoxContainer.get_children():
			if i.get_node("TextureRect").texture != null:
				print(i.get_node("Label2").text," ",int(i.get_node("Label").text))
				PlayerInventory.add_item(i.get_node("Label2").text, int(i.get_node("Label").text))
	print(get_node("ScrollContainer2").money)
	find_parent("bajun").get_node("Steve").gain_money(get_node("ScrollContainer2").money, 0)
	find_parent("bajun").get_node("UserInterFace").update_inventory(PlayerInventory.money, PlayerInventory.juntuan)
	clear_pack()
	pass # Replace with function body.


func _on_TextureButton3_pressed():
#	clear_pack()
	$ScrollContainer.visible = true
	$ScrollContainer3.visible = false
	
	pass # Replace with function body.


func _on_TextureButton_pressed():
#	clear_pack()
	$ScrollContainer.visible = false
	$ScrollContainer3.visible = true
	pass # Replace with function body.
