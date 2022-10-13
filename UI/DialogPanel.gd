extends CanvasLayer

onready var steve = get_tree().get_root().get_node("bajun/Steve")
onready var userInterface = get_tree().get_root().get_node("bajun/UserInterFace")

func _ready():
#	$Control/TextureRect/Label.text = get_parent().get_node("Name/HBoxContainer/middle/name").text
	init()

func init():
	$Control/TextureRect/Label3.percent_visible = 0
	
func _on_Button2_pressed():
	visible = false

func _process(delta):
	$Control/TextureRect/Label3.percent_visible += 0.01


func _on_Button_pressed():
	$Control/TextureRect/Label3.text = "还不快滚？"
	init()


func _on_Button3_pressed():
	visible = false
	steve.gain_speed()
	
	userInterface.get_node("buy_and_sell/Label").text = str(steve.juntuan)
	userInterface.get_node("buy_and_sell/Label2").text = str(steve.money)
	userInterface.get_node("buy_and_sell/Label3").text = str(PlayerInventory.inventory.size()) + "/" + str(PlayerInventory.NUM_INVENTORY_SLOTS)
	userInterface.get_node("buy_and_sell").refresh()
	userInterface.get_node("buy_and_sell").visible = true
	
