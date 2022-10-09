extends Node2D

onready var steve = get_tree().get_root().get_node("bajun/Steve")
onready var userInterface = get_tree().get_root().get_node("bajun/UserInterFace")
func _ready():
	$UserInterFace/AnimationPlayer.play("shade_in")
	yield(get_tree().create_timer(3), "timeout")
	$UserInterFace/AnimationPlayer.play("shade_out")
#	FreeNodes.connect("freeig_orphans", self, "free_it_orphaned")

#func free_it_orphaned():
#	if not is_inside_tree():
#		queue_free()


func _on_TransPort_body_entered(body):#西郊
	SceneChange.goto_scene("res://Level1.tscn", self)
#	get_tree().change_scene("res://Level1.tscn")
	pass # Replace with function body.


func _on_TransPort2_body_entered(body):#监狱
	pass # Replace with function body.


func _on_TransPort3_body_entered(body):#东郊
	pass # Replace with function body.


func _on_Control2_mouse_entered():
	$Control2/npc1.material.set("shader_param/width", 1)
	pass # Replace with function body.


func _on_Control2_mouse_exited():
	$Control2/npc1.material.set("shader_param/width", 0)
	pass # Replace with function body.


func _on_Control2_gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			steve.gain_speed()
			userInterface.get_node("buy_and_sell").refresh()
			userInterface.get_node("buy_and_sell/Label").text = str(steve.juntuan)
			userInterface.get_node("buy_and_sell/Label2").text = str(steve.money)
			userInterface.get_node("buy_and_sell/Label3").text = str(PlayerInventory.inventory.size()) + "/50"
			userInterface.get_node("buy_and_sell").visible = true
			print("double click")
	pass # Replace with function body.
