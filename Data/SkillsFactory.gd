
## 技能工厂
extends Node


## 技能属性
const SkillsProperty = preload("res://system/skill/SkillsProperty.gd")
## 技能场景文件
#const ScnSkills = preload("res://Skill.tscn")
## 技能属性列表
const SkillsPropertyList = SkillsProperty.SkillsProperty

# 存放技能图片的文件夹（这里我创建了这些路径）
const GoodsPicturePath = "res://assets/texture/skills/"


## 技能数据
var skill_data = {}


#------------------------------
#  节点带有的方法
#------------------------------
func _ready():
	## 获取技能json数据
	var file = File.new()
	file.open("res://Data/skill.json", File.READ)
	var skill_json = JSON.parse(file.get_as_text())
	file.close()
	skill_data = skill_json.result



#------------------------------
#  自定义方法
#------------------------------
## 返回一个物品
## @goods_name 物品名称
## @return 返回一个物品的节点
#func get_skills(skill_name: String):
#	if skill_data.has(skill_name):
#		var data = get_skills_data(skill_name)	# 物品数据
#		var res_property = SkillsProperty.new()
#
#		## 设置物品属性资源的属性数据
#		res_property.set_property(data)
#
#		## 返回物品节点
#		var goods = ScnSkills.instance()
#		goods.set_goods_property(res_property)	# 设置物品属性
#		return goods
#	else:
#		print_debug("没有【%s】这个技能" % skill_name)
#		return null



## 返回物品数据
## --------------
## 做这个方法的原因是因为，数据的属性可能与文件的属性数据不一致的问题
## 我们在这里将数据转为 符合物品属性数据格式 的数据
func get_skills_data(skill_name: String):
	var data = skill_data[skill_name]	# 物品数据
	var temp = {}
	
	# 设置资源的格式：变量[属性名] = 属性值
	temp[SkillsPropertyList.Name] = data['skill_ame']
	temp[SkillsPropertyList.Damage] = int(data['damage'])
	temp[SkillsPropertyList.NeedLevel] = int(data['need_level'])
	temp[SkillsPropertyList.AttackRange] = int(data['attack_range'])
	temp[SkillsPropertyList.Description] = data['description']
	temp[SkillsPropertyList.Consume] = int(data['consume'])
	temp[SkillsPropertyList.State] = data['state']
	temp[SkillsPropertyList.Time] = int(data['time'])
	#temp[SkillsPropertyList.Texture] = get_goods_texture(data['Picture'])
	return temp


## 获取物品图片
## @picture_name 物品图片名称
## @return 返回物品的图片
var file = File.new()
func get_goods_texture(picture_name: String) -> Texture:
	var path = GoodsPicturePath + picture_name + ".png"	# 物品图片路径
	
	# 如果存在图片，则返回图片
	if file.file_exists(path):
		return load(path) as Texture
	# 如果不存在，则返回默认的 icon 图片
	else:
		return preload("res://69896-1.png")

