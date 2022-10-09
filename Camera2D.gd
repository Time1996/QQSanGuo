extends Camera2D


func _ready():
	pass

func _physics_process(delta):
	offset_h = rand_range(-5, 5)
	offset_v = rand_range(-5, 5)
