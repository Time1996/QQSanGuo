extends Control


func _ready():
	pass # Replace with function body.


func _on_NPC_mouse_entered():
	$AnimatedSprite.material.set("shader_param/width", 1)


func _on_NPC_mouse_exited():
	$AnimatedSprite.material.set("shader_param/width", 0)


func _on_jiguanxiaoyao_gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			$DialogPanel.visible = true

