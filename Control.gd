extends CanvasLayer
var holding_item = null
onready var max_health = PlayerInventory.max_health
onready var max_magic = PlayerInventory.max_magic

signal health_updated()


func _ready():
	for i in get_node("Character/HBoxContainer").get_children():
		i.visible = false
	pass

func update_text(level, 
					m_health, 
					m_magic, 
					b_damage, 
					b_defend, 
					b_shugong, 
					b_shufang,
					force,
					agility,
					wisdom,
					strong,
					aim
	):
		
	for i in str(level).length():
		get_node("Character/HBoxContainer/"+str(i+1)).texture = load("res://UI/level/"+str(level).substr(i,1)+".png")
		get_node("Character/HBoxContainer/"+str(i+1)).visible = true
#		print('显示等级', level)
	max_health = m_health
	max_magic = m_magic
	$Inventory/Wugong.text = str(b_damage)
	$Inventory/Wufang.text = str(b_defend)
	$Inventory/Shugong.text = str(b_shugong)
	$Inventory/Shufang.text = str(b_shufang)
	$player_state/Force.text = str(force)
	$player_state/Agility.text = str(agility)
	$player_state/Wisdom.text = str(wisdom)
	$player_state/Strong.text = str(strong)
	$player_state/Aim.text = str(aim)
	
func update_inventory(m, j):
	$Inventory/Money.text = str(m)
	$Inventory/Juntuan.text = str(j)
	var cnt = 0
	for i in $Inventory/ScrollContainer/VBoxContainer.get_children():
		if i.get_children().size()!=0:
			cnt += 1
	$Inventory/Backpack.text = str(cnt) + "/50"
	
func update_exp(experience, experience_required):
	var value = int(experience*100/experience_required)
	$exprience/TextureProgress.value = value
	$exprience/Label.text = str(value) + "%"
	$exprience/Control.hint_tooltip = str(experience) + "/" + str(experience_required)

func _on_UserInterFace_health_updated(health, magic):
	$Character/Bar/HealthBar.max_value = max_health
	$Character/Bar/MaigcBar.max_value = max_magic
	$Character/Bar/HealthBar.value = health
	$Character/Health.text = str(health) + "/" + str(max_health)
	$Character/Bar/MaigcBar.value = magic
	$Character/Magic.text = str(magic) + "/" + str(max_magic)
	pass # Replace with function body.

#func load_save_stats(stats): #需要保存的信息 金币 物品等
	


func _on_Button_pressed():
	$Hotbar.visible = !$Hotbar.visible
	$Hotbar.initialize_hotbar()
	pass # Replace with function body.


func _on_Timer_timeout():
#	$Character/Target.visible = false
	pass # Replace with function body.
