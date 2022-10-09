extends KinematicBody2D

export(NodePath)var route

var max_health = PlayerInventory.max_health
var max_magic = PlayerInventory.max_magic
var basic_damage = PlayerInventory.basic_damage
var basic_defende = PlayerInventory.basic_defende
var basic_shugong = PlayerInventory.basic_shugong
var basic_shufang = PlayerInventory.basic_shufang
var money = PlayerInventory.money
var juntuan = PlayerInventory.juntuan
var level = PlayerInventory.level

var key_state ##技能键位
var selected_skill
var skill_damage

var enemy_array = []
var enemy_id ##标记是哪个敌人

var state_machine

onready var enemies = get_tree().get_nodes_in_group("enemy")

onready var userInterface = get_parent().get_node("UserInterFace")

var experience = 0
var experience_pool = 0 #经验池
var experience_required = get_required_experience(level+1)

onready var health = PlayerInventory.max_health
onready var magic = max_health setget _set_health

signal health_updated(health, magic)

var monirable = 0 ##物体进入藤子时 重复true和false来达到 实时检测的目的

var velocity = Vector2()
var cnt = 0
var derection = 0
export var JUMP = -800  #800合适
export var SPEED = 400  #300合适
var state = 0#0默认 1攀爬
var trans = 0#是否符合传送条件
var upOrDown = 0#上下梯子

var attacking = 0#攻击状态

var chase_target_state = 0
var target = 0
var target_derection = 1

export var cant_move = false

func _ready():
#	print(position)
	randomize()
	init()
	$Control/AnimatedSprite.visible = false
	$Control/AnimatedSprite2.visible = false
	state_machine = $AnimationTree.get("parameters/playback")
	$HBoxContainer.visible = false
	$Cure.visible = false
	$fly_left.frame = $fly_right.frame
	for i in $HBoxContainer.get_children():
		i.visible = false
	for i in $Cure.get_children():
		i.visible = false
		
func init():
	
	userInterface.update_text(PlayerInventory.level, PlayerInventory.max_health, PlayerInventory.max_magic,
							 PlayerInventory.basic_damage, PlayerInventory.basic_defende,
							 PlayerInventory.basic_shugong, PlayerInventory.basic_shufang,
							PlayerInventory.force, PlayerInventory.agility,
							PlayerInventory.wisdom, PlayerInventory.strong,
							PlayerInventory.aim
							)

var items_in_range = {} ##掉落物范围检测 暂存数组

func get_required_experience(level):
	return 1*level-1

func gain_experience(amount):
	get_node("HBoxContainer/0").visible = true
	var str_amount = str(amount)
	for i in str_amount.length():
		get_node("HBoxContainer/"+str(i+1)).texture = load("res://EFECTIVE/js/digit/"+str_amount.substr(i,1)+str_amount.substr(i,1)+".png")
		get_node("HBoxContainer/"+str(i+1)).visible = true
	$AnimationPlayer.play("experience")
	experience_pool += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		level_up()
	userInterface.update_exp(experience, experience_required)
	yield($AnimationPlayer, "animation_finished")
	for i in $HBoxContainer.get_children():
		i.visible = false



func level_up():
	PlayerInventory.level += 1
	experience_required = get_required_experience(PlayerInventory.level + 1)
	PlayerInventory.max_health += PlayerInventory.level * 10
	PlayerInventory.max_magic += PlayerInventory.level * 5
	PlayerInventory.basic_damage += PlayerInventory.level * 2
	PlayerInventory.basic_defende += PlayerInventory.level * 1
	PlayerInventory.basic_shugong += PlayerInventory.level
	PlayerInventory.basic_shufang += PlayerInventory.level
	
	$level_up.play()
	$Control/AnimatedSprite3.visible = true
	$Control/AnimatedSprite3.play("default")
	yield($Control/AnimatedSprite3, "animation_finished")
	$Control/AnimatedSprite3.visible = false
	$Control/AnimatedSprite3.stop()
	userInterface.update_text(PlayerInventory.level, PlayerInventory.max_health, PlayerInventory.max_magic,
							 PlayerInventory.basic_damage, PlayerInventory.basic_defende,
							 PlayerInventory.basic_shugong, PlayerInventory.basic_shufang,
							PlayerInventory.force, PlayerInventory.agility,
							PlayerInventory.wisdom, PlayerInventory.strong,
							PlayerInventory.aim
							)
	
func gain_money(amount_m, amount_j):
	PlayerInventory.money += amount_m
	PlayerInventory.juntuan += amount_j
	userInterface.update_inventory(PlayerInventory.money, PlayerInventory.juntuan)
	
func use_item(new_item):
	add_property(new_item)

func add_property(item_name):
	var temp_item = jsonData.item_data[item_name]
	if temp_item.AddHealth != null:
		gain_health(int(temp_item.AddHealth))
	if temp_item.AddEnergy != null:
		gain_magic(int(temp_item.AddEnergy))

func gain_speed():
	userInterface.get_node("Character/state/speed").visible = true
	SPEED = 2 * 400
	$speed.start(10)
	$fly_left.visible = true
	$fly_right.visible = true
	
var str_amount
func gain_recover(duration_time, amount):
	userInterface.get_node("Character/state/recover").visible = true
	$health.start(duration_time)
	$small_health.start(1)
	$recover.visible = true
#	yield($recover,"animation_finished")
#	print("cure")
	
	str_amount = str(amount)
	
	
func gain_health(value):
	health += value
	if health > PlayerInventory.max_health:
		health = PlayerInventory.max_health

func gain_magic(value):
	magic += value
	if magic > PlayerInventory.max_magic:
		magic = PlayerInventory.max_magic

func _input(event):
	if event.is_action_pressed("pickUp"):
		if items_in_range.size() > 0:
			var pickup_item = items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			gain_money(0, 0)
			items_in_range.erase(pickup_item)


func _physics_process(delta):
	if chase_target_state == 1:##释放技能 跑到能达到怪物的地方
		move_to_target(delta)
	else:
		game_play(delta)




func move_to_target(delta):
#	if sqrt(pow(enemy_id.position.y-position.y, 2) + pow(enemy_id.position.x-position.x, 2)) <= 30:
	target = abs(position.x - enemy_id.position.x) + 30
	target_derection = position.x - enemy_id.position.x
	chase_target_state = 1
	if target_derection > 0:
		target_derection = -1
		$Control.rect_scale.x = -1
	else:
		target_derection = 1
		$Control.rect_scale.x = 1
	##在范围内了 双方同时开始动画 进行伤害计算 并播放动画
#	print(enemy_id.position)
	if sqrt(pow(enemy_id.position.y-position.y, 2) + pow(enemy_id.position.x-position.x, 2)) <= 30:
		yield(get_tree().create_timer(5), "timeout") ##5秒后 当前怪物失去目标 回复普通状态
		enemy_id.state = "IDLE"
		userInterface.get_node("Character/Target").visible = false
		enemy_id.get_node("Sprite").visible = false
#		chase_target_state = 0
		return
	if target <= 175: #skill_dist 100
		chase_target_state = 0
		enemy_id.injury(basic_damage) ##指定敌人收到伤害 +skill_damage
#		state_machine.travel("idle")
		attack()
		return
		
	velocity.x = delta * SPEED * target_derection * 50
	state_machine.travel("run")
	velocity.y = 0
	velocity = move_and_slide(velocity)
#	yield(get_tree(), "idle_frame")


func game_play(delta):
	velocity.x = 0
	$CollisionShape2D.disabled = false
	if not is_on_floor():
		if state == 0:
			if derection == 1:
				velocity.x = SPEED * derection
			elif derection == -1:
				velocity.x = SPEED * derection
			##$Sprite.set()
			state_machine.travel("jump")
		else:
			if attacking == 0:##不在攻击状态中 才可以上下
				if Input.is_action_pressed("up"):
					upOrDown = -1
				elif Input.is_action_pressed("down"):
					upOrDown = 1
				else:
					state = 1
					upOrDown = 0
				state_machine.travel("clim")
				velocity.x = 0
	else:
		derection = 0
		if state == 0 and attacking == 0:##不在攻击状态中 才可以
			if Input.is_action_pressed("right"):
				derection = 1
				state_machine.travel("run")
				$Control.rect_scale.x = 1
				if Input.is_action_just_pressed("jump"):
					derection = 1
					velocity.y = JUMP
					state_machine.travel("jump")
			elif Input.is_action_pressed("left"):
				derection = -1
				state_machine.travel("run")
				$Control.rect_scale.x = -1
				if Input.is_action_just_pressed("jump"):
					derection = -1
					velocity.y = JUMP
					state_machine.travel("jump")
			elif Input.is_action_just_pressed("jump"):
				velocity.y = JUMP
#			elif Input.is_action_pressed('attack'):
#				key_state = 'D' ##这里先用技能
#				var min_dist = 99999999
##				min_dist = closet_enemy(min_dist)
#				closet_enemy(min_dist)
#				move_to_target(delta, min_dist)
			
			elif trans == 1 and Input.is_action_pressed("up"):
				pass
#				get_tree().change_scene("res://JiangLinXiJiao.tscn")
			elif Input.is_action_just_pressed("tab"):
				if enemy_id != null:
					enemy_id.get_node("Sprite").visible = false
#				enemy_id = null
				closet_enemy(99999999)
				for i in enemy_array:
					print(i, " ", i.name)
				enemy_id = enemy_array.back()
#				print(enemy_id," ", enemy_id.name)
				if enemy_id != null:
					enemy_id.get_node("Sprite").visible = true
					move_to_target(delta)
#				var enemy = enemies[int(randi()%enemies.size())]
#				enemy.get_node("Sprite").visible = true
#				userInterface.get_node("Character/Target").visible = true
#				userInterface.get_node("Character").get_node("Target").get_node("profile").texture = load("res://Monster_ui/profile/"+enemy.Name+".png")
#				userInterface.get_node("Character").get_node("Target").get_node("name").text = enemy.Name
#				userInterface.get_node("Character").get_node("Target").get_node("health_bar").value = enemy.health
				pass
			else:
				state_machine.travel("idle")
		else:
			if attacking == 0:##不在攻击状态中 才可以上下
				if Input.is_action_pressed("up"):
					state = 1
					velocity.x = 0
					upOrDown = -1
					state_machine.travel("clim")
				elif Input.is_action_pressed("down"):
					$CollisionShape2D.disabled = true
					state = 1
					upOrDown = 1
					state_machine.travel("clim")
				else:
					state = 1
					velocity.x = 0
					upOrDown = 0
	#Gravity
	if state != 1:#不等于攀爬
		velocity.y += 30
		velocity.x = SPEED * derection
	else:
		velocity.y = 300 * upOrDown
		if Input.is_action_pressed("left") and Input.is_action_just_pressed("jump"):
			$Control.rect_scale.x = -1
			state = 0
			derection = -1
			velocity.y = JUMP
		elif Input.is_action_pressed("right") and Input.is_action_just_pressed("jump"):
			$Control.rect_scale.x = 1
			state = 0
			derection = 1
			velocity.y = JUMP
		elif Input.is_action_just_pressed("jump"):
			derection = 0
			state = 0
	if cant_move:
		velocity = Vector2(0, 0)
	velocity = move_and_slide(velocity, Vector2.UP)
	#velocity.x = lerp(velocity.x, 0, 0.1)

func injury(damage, crit = false):
	_on_Steve_health_updated(damage, crit)

func die():
	state_machine.travel("die")
	set_physics_process(false)
	
func closet_enemy(min_dist):
	## 遍历敌人组 选择两点间距离最近的敌人
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemy_array.clear()
	for i in enemies:
		var dist = sqrt(pow(i.position.y-position.y, 2) + pow(i.position.x-position.x, 2))
		if dist < min_dist and abs(i.position.y-position.y) <= 30:
			min_dist = dist
			velocity.x = i.position.x - position.x
			enemy_array.append(i)
		else:
			if enemy_array.has(i):
				enemy_array.erase(i)
	return
			
#	for i in enemies:
#		if sqrt(pow(i.position.y-position.y, 2) + pow(i.position.x-position.x, 2)) == min_dist:
#			#i.call_deferred("injury", 1)
##			userInterface.get_node("Character").get_node("Target").visible = true
##			userInterface.get_node("Character").get_node("Target").get_node("profile").texture = load("res://Monster_ui/profile/"+i.Name+".png")
##			userInterface.get_node("Character").get_node("Target").get_node("name").text = i.Name
##			userInterface.get_node("Character").get_node("Target").get_node("health_bar").value = i.get_node("HealthBar").get_node("HealthBar").value
##			print(i.get_node("HealthBar").get_node("HealthBar").value)
#			target = abs(position.x - i.position.x) + 30
#			target_derection = position.x - i.position.x
#			if target_derection > 0:
#				target_derection = -1
#			else:
#				target_derection = 1
#			chase_target_state = 1
#			break

func _on_climb_body_exited(body):
	state = 0
	monirable = 0

func _on_Timer_timeout():
	attacking = 0

func _on_HitBox_body_entered(body):
	if !(body is KinematicBody2D):
		print("fuck that's not enemy!")
	if body.is_in_group("enemy"):
		var num = int(rand_range(1, 5))
		for i in num:
			var temp_damage = basic_damage
			var factor = rand_range(0, 1)
			if factor <= 0.5:
				temp_damage *= rand_range(1.2, 2)
				body.call_deferred("injury", -int(temp_damage), true)  ##对敌造成汇总伤害 自身基础+技能+装备\
			else:
				body.call_deferred("injury", -int(temp_damage))
		
func _on_climb_body_entered(body):
	monirable = 1
	if cnt > 1 and Input.is_action_pressed("up") or Input.is_action_pressed("down"):
		state = 1
	cnt+=1
	if cnt > 10:
		cnt = 2

func _on_Steve_injury():
	health -= 10
	
	pass # Replace with function body.

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health, magic)
		if health <= 0:
			dead()
			
func dead():
	state_machine.travel("die")
	yield($Control/Sprite,"animation_finished")
	##弹出死亡界面 这里先重新载入地图
	get_tree().change_scene("res://Level1.tscn")
	
func _on_Steve_health_updated(value, crit = false):
	health += value
	if health <= 0:
		velocity = Vector2.ZERO
		dead()
	state_machine.travel("injury")
	$FCTmgr.show_value(value, crit)
	get_parent().get_node("UserInterFace").emit_signal("health_updated",health, magic)
	yield($Control/AnimatedSprite,"animation_finished")
	pass # Replace with function body.


func _on_BattleTime_timeout():
	get_parent().get_node("Battle").stop()
	if	get_parent().get_node("AudioStreamPlayer").playing == false:
		get_parent().get_node("AudioStreamPlayer").play()
	pass # Replace with function body.


func _on_pickableArea_body_entered(body):
	items_in_range[body] = body

func _on_pickableArea_body_exited(body):
	if items_in_range.has(body):
		items_in_range.erase(body)

func attack():
	attacking = 1
	
	if get_parent().has_node("Battle") and get_parent().get_node("Battle").playing == false:
		get_parent().get_node("AudioStreamPlayer").stop()
		get_parent().get_node("Battle").play()
		get_parent().get_node("BattleTime").start(25)

#	match selected_skill:
#		SkillsFactory.skill_data[selected_skill].skill_type
#		var skill = load("res://Skill.tscn").instance()
#		skill.skill_name = skill_data[selected_skill].skill_name ##一句话即可获取所有技能数据 都存入skill节点了 拿来用即可
#		state_machine.travel(skill.skill_name)
#		get_node("BattleSound").stream = load("res://MUSIC/js/"+skill.skill_name+".wav")
#		skill_damage = skill.caculate(basic_damage, defend)
	if key_state == 'W':
		get_node("BattleSound").stream = load("res://MUSIC/js/hhfl.wav")
		state_machine.travel("hhfl")
	elif key_state == 'A':
		get_node("BattleSound").stream = load("res://MUSIC/js/40.wav")
		state_machine.travel("attack")
	elif key_state == 'D':
		state_machine.travel("40")
		get_node("BattleSound").stream = load("res://MUSIC/js/40.wav")
	get_node("BattleSound").play()
#	yield($AnimationPlayer,"animation_finished")
#	attacking = 0
	$Timer.start(0.8)

func _on_self_heal_timeout():
	health += 4 ##每秒回复4点生命
	
	if health > PlayerInventory.max_health:
		health = PlayerInventory.max_health
	magic += 2 ##2点魔法
	if magic > PlayerInventory.max_magic:
		magic = PlayerInventory.max_magic
	get_parent().get_node("UserInterFace").emit_signal("health_updated",health, magic)
	pass # Replace with function body.

func get_save_stats():
	return {
		'filename' : get_filename(),
		'parent' : get_parent().get_path(),
		'x_pos' : position.x,
		'y_pos' : position.y,
		'stats' : {
			'max_health' : PlayerInventory.max_health,
			'max_magic' : PlayerInventory.max_magic,
			'health' : health,
			'magic' : magic,
			'basic_damage' : PlayerInventory.basic_damage,
			'basic_defende' : PlayerInventory.basic_defende,
			'money' : PlayerInventory.money,
			'juntuan' : PlayerInventory.juntuan,
			'exprience' : experience_pool,
		}
	}

func load_save_stats(stats): #需要保存的信息 目前是位置 属性
	position = Vector2(stats.x_pos, stats.y_pos)
	PlayerInventory.max_health = stats.stats.max_health
	PlayerInventory.max_magic = stats.stats.max_magic
	health = stats.stats.health
	magic = stats.stats.magic
	PlayerInventory.basic_damage = stats.stats.basic_damage
	PlayerInventory.basic_defende = stats.stats.basic_defende
	PlayerInventory.money = stats.stats.money
	PlayerInventory.juntuan = stats.stats.juntuan
	experience_pool = stats.stats.exprience




func _on_speed_timeout():
	userInterface.get_node("Character/state/speed").visible = false
	$speed.stop()
	$fly_left.visible = false
	$fly_right.visible = false
	SPEED = 400
	pass # Replace with function body.


func _on_health_timeout():
	userInterface.get_node("Character/state/recover").visible = false
	$health.stop()
	$recover.stop()
	$recover.visible = false
#	$small_health.paused
	pass # Replace with function body.


func _on_small_health_timeout():
	print(str_amount)
	gain_health(int(str_amount))
	for i in str_amount.length():
		get_node("Cure/"+str(i)).texture = load("res://EFECTIVE/digit/"+str_amount.substr(i,1)+".png")
		get_node("Cure/"+str(i)).visible = true
	$AnimationPlayer2.play("cure")
	
	yield($AnimationPlayer2, "animation_finished")
	for i in $Cure.get_children():
		i.visible = false
	$small_health.start(1)
	pass # Replace with function body.


func _on_pickableArea_mouse_entered():
	print("FFCUUK")
	pass # Replace with function body.
