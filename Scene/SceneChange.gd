extends CanvasLayer

var max_load_time = 10000

var img = load("res://ANIMATION/beauty_picture/7347-1.png")
var img2 = load("res://ANIMATION/beauty_picture/7348-1.png")
var img3 = load("res://ANIMATION/beauty_picture/7349-1.png")
var img4 = load("res://ANIMATION/beauty_picture/7350-1.png")
var img5 = load("res://UI/loading/7810-1.png")


func _ready():
	randomize()
	FreeNodes.free_orphaned_nodes()
	pass

func choose(arr):
	arr.shuffle()
	return arr.front()

func goto_scene(path, current_scene):
	var loader = ResourceLoader.load_interactive(path)
	
	var control = TextureRect.new()
	control.texture = choose([img,img2,img3,img4,img5])
	print(get_viewport().size)
	control.rect_size = get_viewport().size
	get_tree().get_root().call_deferred("add_child", control)
	
	var loading_bar = load("res://Scene/LoadingBar.tscn").instance()
	get_tree().get_root().call_deferred("add_child", loading_bar)
	
	
	var t = OS.get_ticks_msec()
	current_scene.queue_free()
	while OS.get_ticks_msec() - t < max_load_time:
		
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			#loading complete
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred("add_child", resource.instance())
			
			control.queue_free()
			loading_bar.queue_free()
			
			break
		elif err == OK:
			#still loading
			var progress = float(loader.get_stage()) / loader.get_stage_count()
#			print(progress)
			loading_bar.value = progress * 100
		else:
			print("load error!")
			break
		yield(get_tree(), "idle_frame")

