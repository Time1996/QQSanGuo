extends Node2D

onready var steve = get_tree().get_root().get_node("bajun/Steve")
onready var userInterface = get_tree().get_root().get_node("bajun/UserInterFace")
var load_scene = null
func _ready():
	$UserInterFace/AnimationPlayer.play("shade_in")
	yield(get_tree().create_timer(3), "timeout")
	$UserInterFace/AnimationPlayer.play("shade_out")
#	FreeNodes.connect("freeig_orphans", self, "free_it_orphaned")

#func free_it_orphaned():
#	if not is_inside_tree():
#		queue_free()


func _on_TransPort_body_entered(body):#西郊
#	load_scene = load("res://Level1.tscn").instance()
	SceneChange.goto_scene(load_scene, self)
#	get_tree().change_scene("res://Level1.tscn")
	pass # Replace with function body.


func _on_TransPort2_body_entered(body):#监狱
	pass # Replace with function body.


func _on_TransPort3_body_entered(body):#东郊
	pass # Replace with function body.

func _exit_tree():
#	load_scene.free()
	pass
