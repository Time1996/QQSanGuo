extends CanvasLayer

onready var steve = get_tree().get_root().get_node("bajun/Steve")
onready var userInterface = get_tree().get_root().get_node("bajun/UserInterFace")

export var custom_dialog1 = ""
export var custom_dialog2 = ""

func _ready():
	$Control/TextureRect/Label.text = get_parent().get_node("Name/HBoxContainer/middle/name").text
	$Control/TextureRect/Label3.text = custom_dialog1
	init()

func init():
	$Control/TextureRect/Label3.percent_visible = 0
	
func _on_Button2_pressed():
	visible = false
	$Control/TextureRect/Label3.text = custom_dialog1

func _process(delta):
	$Control/TextureRect/Label3.percent_visible += 0.01

func _on_Button_pressed():
	$Control/TextureRect/Label3.text = custom_dialog2
	init()



func _on_Button3_pressed():
	self.visible = false
	get_parent().get_node("TransPortation").visible = true
