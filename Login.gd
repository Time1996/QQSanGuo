extends Control
#var level = load("res://Level1.tscn")

func _ready():
	FreeNodes.connect("freeig_orphans", self, "free_it_orphaned")

func _process(delta):
	if $"9023-1".position.x < -600:
		$"9023-1".position.x = 600
	$"9023-1".position.x -= delta * 20
	if $"9024-1".position.x > 600:
		$"9024-1".position.x = -600
	$"9024-1".position.x += delta * 30
	if $AnimatedSprite3.position.x < -600:
		$AnimatedSprite3.position.x = 600
	$AnimatedSprite3.position.x -= delta * 40
	if $AnimatedSprite4.position.x < -600:
		$AnimatedSprite4.position.x = 600
	$AnimatedSprite4.position.x -= delta * 45
	if $AnimatedSprite5.position.x < -600:
		$AnimatedSprite5.position.x = 600
	$AnimatedSprite5.position.x -= delta * 50

func free_it_orphaned():
	if not is_inside_tree():
		queue_free()

func _on_Exit_pressed():
	queue_free()
	get_tree().quit()
	pass # Replace with function body.


func _on_Login_pressed():
	SceneChange.goto_scene("res://Level1.tscn", self)
#	get_tree().change_scene_to(level)
	pass # Replace with function body.


func _on_Load_pressed():
	SceneChange.goto_scene("res://Level1.tscn", self)
#	get_tree().change_scene_to(level)
	SaveState.load_game()
	pass # Replace with function body.
