extends Node


var skill_data

func _ready():
	var file = File.new()
	file.open("res://Data/skill.json", File.READ)
	var skill_json = JSON.parse(file.get_as_text())
	file.close()
	skill_data = skill_json.result
	print(skill_data)
