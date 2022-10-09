extends OptionButton


func _ready():
	for i in range(1, 99):
		add_item(str(i)+"个", i)
	pass
