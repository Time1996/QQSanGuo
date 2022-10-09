## Goods Property
## 资源类型，用于 GoodsList 显示属性
tool	# 工具类，用于在编辑器中实时显示效果
extends Node

## 物品属性（物品的属性名字写在下面，用于后面方便获取与设置物品的属性）
## 这样，我们只用在这里添加键值，然后修改的时候也不会影响以后的通过 key 值
## 去设置属性的代码
const SkillsProperty = {
	Name = "skill_name",
	NeedLevel = "need_level",
	Damage = "damage",
	Description = "description",
	AttackRange = "attack_range",
	Consume = 'consume',
	State = 'state',
	Time = 'time'
}


signal goods_texture_changed(texture_)	# 技能贴图发生改变信号


export var skill_name = ""	# 技能名
export (Texture) var goods_texture setget set_goods_texture	# 技能图片
export (String, MULTILINE) var goods_description # 物品描述
export var damage = 0	# 伤害值
export var move_speed = 0	# 移动速度
export var attack_range = 0	# 攻击范围


#------------------------------
#  setget
#------------------------------
## 设置物品的图片
func set_goods_texture(value) -> void:
	goods_texture = value
	emit_signal("goods_texture_changed", value)

## 返回物品的属性
func get_property() -> Dictionary:
	var property_list = SkillsProperty.values()	# 获取所有属性名
	var data = {}
	for property in property_list:
		var property_value = get(property)
		data[property] = property_value
#	print(data)
	return data

## 设置物品的属性
func set_property(property_dict: Dictionary) -> void:
	for key in property_dict:
		var value = property_dict[key]
		set(key, value)
