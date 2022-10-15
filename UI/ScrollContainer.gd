extends ScrollContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()


func refresh():
#	$HScrollBar.value = 1
#	$Label.text = str(PlayerInventory.juntuan)
#	$Label2.text = str(PlayerInventory.money)
#	$Label3.text = str(PlayerInventory.inventory.size()) + "/" + str(PlayerInventory.NUM_INVENTORY_SLOTS)
#	clear_pack()
	
	var a = 0
	var b = 0
	for i in $VBoxContainer.get_children():
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
