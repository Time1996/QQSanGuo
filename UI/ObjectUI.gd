extends Control

export var object_type = 1
export (Texture) var object_image
export (int,1,100) var object_level
export (String) var object_name
func _ready():
	var file = File.new()
	var temp = StreamTexture.new()
	object_image = load("res://.import/69896-1.png-f8fc3a62624551ac1476a52ae62c7fb6.stex") as Texture
	pass
