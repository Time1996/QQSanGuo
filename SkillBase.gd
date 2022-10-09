extends Node2D
class_name SkillBase

enum SKILL_STATE{
	IDLE
	CASTED
	CASTING
	FINISHED
}

export (NodePath) var host_node = @'..'
export (String) var skill_name
export (Texture) var skill_icon
export (String) var input_key
export (int, 0 , 10000) var cast_dist
export (int, 0 , 10000) var need_level
export (int, 0 , 10000) var damage
export (float, 0, 10000) var cooldown = 1.0
export (float, 0, 10000) var duration = 0.5
export (String) var job_name

var _skill_state: int = SKILL_STATE.IDLE
var _can_cast: bool = true
var _duration_countdown: float = -1

var _cooling_timer := Timer.new()

var skill_data = {}

func _ready():
	var picture_path = "res://assets/texture/js"
	skill_data = SkillsFactory.skill_data[skill_name]
	cast_dist = skill_data["attack_range"]
	need_level = skill_data["need_level"]
	damage = skill_data["damage"]
	print(damage)
	print(skill_data)
	
	set_physics_process(false)
	
	if input_key == '':
		print("未设置按键")
		set_process(false)
		
	if not _cooling_timer.is_inside_tree():
		_cooling_timer.connect("timeout", self, "cooling_complete")
		_cooling_timer.one_shot = true
		_cooling_timer.autostart = false
		add_child(_cooling_timer)
		
	##设置相应的技能图标
	$background.texture = skill_icon
	
#func _unhandled_input(event):
#	if event.is_action_pressed(input_key):
#		if is_can_cast():
#			cast_skill()
func _physics_process(delta):
	if _duration_countdown <= 0:
		cast_over()
		set_physics_process(false)
		return
	_duration_countdown -= delta
	duration_process(delta)

func cast_skill():
	_start_duration_countdown()
	_start_cooldown_countdown()
	_can_cast = false
	switch_skill_state(SKILL_STATE.CASTED)
	
func duration_process(delta):
	pass

func cast_over():
	if _skill_state != SKILL_STATE.IDLE:
		switch_skill_state(SKILL_STATE.FINISHED)

func is_can_cast() -> bool:
	"""能否施放技能
	< 后续重写时，可再添加魔法值等属性是否足够的判断，来确定可否施放技能 >
	"""
	return _can_cast && _skill_state == SKILL_STATE.IDLE


func cooling_complete() -> void:
	"""技能冷却完成"""
	switch_skill_state(SKILL_STATE.IDLE)
	_can_cast = true


func switch_skill_state(state):
	"""切换技能状态"""
	_skill_state = state



#============================================
#		最终的方法（不能重写的方法）
#============================================
func _start_duration_countdown() -> void:
	"""开启持续技能倒计时"""
	if duration <= 0:
		cast_over()
		return
	switch_skill_state(SKILL_STATE.CASTING)
	_duration_countdown = duration
	set_physics_process(true)


func _start_cooldown_countdown() -> void:
	"""开始冷却时间倒计时"""
	if cooldown > 0 :	_cooling_timer.start(cooldown)
	else:				_cooling_timer.start(0.001)


func get_timer_once(
	wait_time: float,
	target: Object = null,
	method: String = ""
) -> Timer:
	"""返回一个一次性的计时器
	< 计时器结束后调用指定的方法，用于那些需要间隔时间施放的「立即施放」技能 >
	"""
	var _timer = Timer.new()
	if wait_time <= 0:	_timer.wait_time = 0.001
	else:				_timer.wait_time = wait_time
	_timer.connect("timeout", self, '__on_Timer_timeout', [_timer])
	_timer.autostart = true
	_timer.one_shot = true
	if target != null: 
		_timer.connect("timeout", target, method)
	add_child(_timer)
	return _timer

func caculation(attack, defence): ##传入人物的攻击 和 怪物的防御
	var damage = int(attack - defence)
	return damage

func __on_Timer_timeout(timer: Timer) -> void:
	timer.queue_free()


func _get_host_node() -> Node2D:
	"""获取节点的宿主"""
	return get_node(host_node) as Node2D
