extends Label

##浮动文本伤害

func show_value(value, travel, duration, spread, crit=false):
	
	var value_str = str(value)
	for i in value_str.length():
#		$HBoxContainer/T1.texture = load("res://EFECTIVE/js/digit/"+value_str.substr(i, 1)+".png")
		get_node("HBoxContainer/"+str(i+1)).texture = load("res://EFECTIVE/js/digit/"+value_str.substr(i, 1)+".png")
		get_node("HBoxContainer/"+str(i+1)).visible = true
#	text = value
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	rect_pivot_offset = rect_size / 2
	$Tween.interpolate_property(self, "rect_position", rect_position, 
								rect_position+movement, duration,
								Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a",
								1.0, 0.0, duration,Tween.TRANS_LINEAR,
								Tween.EASE_IN_OUT)
	if crit:
		modulate = Color(1, 0, 0)
		$Tween.interpolate_property(self, "rect_scale",
									rect_scale*2, rect_scale,
									0.4, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	queue_free()

func _ready():
	var box_size = $HBoxContainer.get_children()
	for i in box_size:
		i.visible = false
	pass
