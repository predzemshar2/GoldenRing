extends Node3D

var robot_node

var tween: Tween
var t=0
func _ready(): 
	# Распаковываем ссылку, чтобы не было проблем с владением
	robot_node = $"Robert01 (2)"
	
func _physics_process(delta: float):
	# Получаем позицию маркера
	t+=delta
	if t>1:
		t=0
		
		var marker_pos = Game.marker_for_robot

		# Добавляем случайный шум к позиции
		var noise = Vector3(randf(), randf(), randf())*.1
		var target_pos = marker_pos + noise
#		print("move rob:", target_pos)
		# Запускаем анимацию, если tween активен
		tween = create_tween()
		tween.tween_property(robot_node,"global_position",target_pos,1)
