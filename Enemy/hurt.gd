extends HBoxContainer

export var travel = Vector2(0, -80)
export var duration = 2
export var spread = PI/2

func _ready():
	
#	queue_free()
	pass

func show_value(value, crit = false):
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	rect_pivot_offset = rect_size / 2
	self.visible = true
	get_parent().get_node("Tween").interpolate_property(self, "rect_position", rect_position, 
								rect_position+movement, duration,
								Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_parent().get_node("Tween").interpolate_property(self, "modulate:a",
								1.0, 0.0, duration,Tween.TRANS_LINEAR,
								Tween.EASE_IN_OUT)
#	if crit:
#		modulate = Color(1, 0, 0)
#		$Tween.interpolate_property(self, "rect_scale",
#									rect_scale*2, rect_scale,
#									0.4, Tween.TRANS_BACK, Tween.EASE_IN)
	get_parent().get_node("Tween").start()
	yield(get_parent().get_node("Tween"), "tween_all_completed")
	self.visible = false
