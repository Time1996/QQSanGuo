extends KinematicBody2D

var mouse_shape = preload("res://assets/mouse/28158-1.png")
var mouse_default = preload("res://assets/mouse/28168-1.png")

signal monster_die

export var attack1 = 2#攻击力
export var defend = 1#防御力
export var max_health = 100#初始最大生命
export var health = 100#血条
export var attack_range = 100#攻击范围

var attacking = 0
var injurying = 0
var time = 0
onready var Name = get_node("Name").get_node("HBoxContainer").get_node("middle/name").text
onready var userInterface = get_parent().get_node("UserInterFace")
var itemDrop = preload("res://ItemDrop.tscn")

enum{
	IDLE,
	NEW_DIRECTION,
	MOVE,
	DIE,
	COMBAT,
	INJURY,
	PRECOMBAT
}

var SPEED = 3800
var velocity = Vector2()
var state = MOVE
var direction = Vector2.RIGHT
var player = null
var state_machine

func init():
	state_machine = $AnimationTree.get("parameters/playback")
	time = 0
	$HealthBar.visible = true
	$Name.visible = true
	$HealthBar/HealthBar.value = max_health
	$Sprite.visible = false
	randomize()
	
func _ready():
	init()
	
func _process(delta):
	match state:
		IDLE:
			#init()
			state_machine.travel("idle")
		NEW_DIRECTION:
			direction = choose([Vector2.RIGHT, Vector2.LEFT])
			state = choose([IDLE, MOVE])
		MOVE:
			move(delta)
		DIE:
			dead()
		INJURY:
			pass
		COMBAT:
			if player:
				var dist = player.position.x - position.x
				velocity.y = 0
				$Timer.stop()
				$"non-combat".stop()
				if dist < 0:
					$AnimatedSprite.flip_h = true
				else:
					$AnimatedSprite.flip_h = false
				if abs(dist) <= attack_range:##玩家在怪物攻击范围内 便开始攻击	
					attacking = 1
#					print("攻击")
					print("猴子")
					
					if $Timer.time_left != 0:
						$Timer.start()
				else:
					move_to_player(delta)
			else:
				if time == 0:
					$"non-combat".start(5)
					time = 1
					print("进入非战斗状态 倒计时5秒开始")
				
			
func move_to_player(delta):
	state_machine.travel("run")
	var dist = player.position.x - position.x
	print(dist)
	velocity.y = 0
	if dist < 0:
		$AnimatedSprite.flip_h = true
		velocity = Vector2.LEFT * SPEED * delta
	else:
		$AnimatedSprite.flip_h = false
		velocity = Vector2.RIGHT * SPEED * delta
	velocity = move_and_slide(velocity)
func attack(player):
	$attack.play()
	get_parent().get_node("Steve").emit_signal("health_updated", attack1)
	state_machine.travel("attack")
	yield($AnimatedSprite,"animation_finished")
	
func check_border():##边缘检测 目前是检测左右两边 返回正确方向
	
	if !($floor_left.is_colliding()):
		direction = Vector2.RIGHT
	if !($floor_right.is_colliding()):
		direction = Vector2.LEFT
	return direction

func move(delta):
	state_machine.travel("run")
	direction =  check_border()
	
	if direction == Vector2.RIGHT:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	
	if injurying == 1:
		velocity = Vector2(0, 0)
	else:
		velocity = direction * SPEED * delta
	velocity = move_and_slide(velocity)

func injury(damage):
	var health = $HealthBar/HealthBar.value
	damage = rand_range(1.1, 2) * damage
	if $deathAndInjury.playing == false:
		$deathAndInjury.play()
	#$Tween.interpolate_property(self, "modulate", Color(255,255,255,0), Color(255, 255, 255, 1), 1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	#$Tween.start()
	
	state_machine.travel("injury")
	if health <= 0:
		state = DIE
	else:
		state = COMBAT
	
	health -= damage
	$HealthBar/HealthBar.value = health
	userInterface.get_node("Character").get_node("Target").visible = true
	userInterface.get_node("Character").get_node("Target").get_node("profile").texture = load("res://Monster_ui/profile/"+Name+".png")
	userInterface.get_node("Character").get_node("Target").get_node("name").text = Name
	userInterface.get_node("Character").get_node("Target").get_node("health_bar").value = health
	
	var crit = rand_range(0, 1)
	if crit < 0.5:
		damage *= 1.5
		
		$critical_attack.visible = true
		$"407-1".visible = true
		$AnimatedSprite2.visible = true
		$AnimatedSprite2.frame = 0
		$AnimatedSprite2.play("2")
		
		var offset = Vector2()
		offset.x = rand_range(-15, 15)
		offset.y = rand_range(-15, 15)
		var newpos = get_parent().get_node("Steve/Camera2D").get_position()
		var oldpos = newpos
		newpos += offset
		get_parent().get_node("Steve/Camera2D").set_position(newpos)
		yield(get_tree().create_timer(0.18),"timeout")
		get_parent().get_node("Steve/Camera2D").set_position(oldpos)
		yield(get_tree().create_timer(0.18),"timeout")
		$critical_attack.visible = false
		$AnimatedSprite2.stop()
		$AnimatedSprite2.visible = false
		$"407-1".visible = false
		
		$FCTmgr.show_value(damage, true)
	else:
		$FCTmgr.show_value(damage, false)
	
	
#		yield($AnimatedSprite, "animation_finished")
	
		
func Drop():
	##死后有概率掉落物品
	#if randi()%2:
		
	var item = itemDrop.instance()
	item.position = position
	get_parent().add_child(item)
	
func dead():
	state_machine.travel("die")
	set_process(false)
	if $deathAndInjury.playing == false:
		$deathAndInjury.play()
	$Tween.interpolate_property(self, "modulate:a", 1, 0, 1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
	
	Drop()
	emit_signal("monster_die")
	userInterface.get_node("Character").get_node("Target").visible = false
	get_parent().get_node("Steve").enemy_id = null
	remove_from_group("enemy")
	yield($AnimatedSprite, "animation_finished")
	
	queue_free()
	
func choose(array):
	array.shuffle()
	return array.front()

func _on_Timer_timeout():
	$Timer.wait_time = choose([1]) #0.5 1 1.5
	if attacking == 0:
		state = choose([IDLE, NEW_DIRECTION, MOVE])
	else:
		state = COMBAT
		attack(player)
		
func _on_Area2D_body_entered(body):
	print("找到玩家")
	player = body
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	print("丢失玩家")
	player = null
	pass # Replace with function body.



func _on_noncombat_timeout():
	init()
	$Timer.start(0.1)
	time = 0
	attacking = 0
	pass # Replace with function body.



func _on_mouse_event_mouse_entered():
	$AnimatedSprite.material.set("shader_param/width", 1)
	pass # Replace with function body.


func _on_mouse_event_mouse_exited():
	$AnimatedSprite.material.set("shader_param/width", 0)
	pass # Replace with function body.
