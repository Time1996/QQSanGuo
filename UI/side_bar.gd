extends Control

var steve

func _ready():
	steve = find_node("Steve")


func _on_Button6_pressed():
	get_parent().get_node("SaveAndLoad").visible = !get_parent().get_node("SaveAndLoad").visible
	pass # Replace with function body.



func _on_Button2_pressed():
	print(PlayerInventory.inventory)
	find_parent("UserInterFace").update_text(PlayerInventory.level, PlayerInventory.max_health, PlayerInventory.max_magic,
											 PlayerInventory.basic_damage, PlayerInventory.basic_defende,
											 PlayerInventory.basic_shugong, PlayerInventory.basic_shufang,
											PlayerInventory.force, PlayerInventory.agility,
											PlayerInventory.wisdom, PlayerInventory.strong,
											PlayerInventory.aim
	)
	find_parent("UserInterFace").update_inventory(PlayerInventory.money, PlayerInventory.juntuan)
	get_parent().get_node("Inventory").visible = !get_parent().get_node("Inventory").visible
	pass # Replace with function body.


func _on_Button_pressed():
	get_parent().get_node("player_state").visible = !get_parent().get_node("player_state").visible
	pass # Replace with function body.


func _on_Button3_pressed():
	get_parent().get_node("player_skill").visible = !get_parent().get_node("player_skill").visible
	pass # Replace with function body.


func _on_Button5_pressed():
	get_parent().get_node("player_task").visible = !get_parent().get_node("player_task").visible
	pass # Replace with function body.
