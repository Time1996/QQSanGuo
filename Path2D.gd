extends Path2D

onready var follow = $PathFollow2D

func _ready():
	pass

func _physics_process(delta):
	follow.set_offset(follow.get_offset() + 100 * delta)
