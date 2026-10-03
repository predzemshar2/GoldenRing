extends Node3D

@export var ship: Node3D
@export var cinematic_camera: Camera3D
@export var landing_point: Marker3D
@export var player: CharacterBody3D

@export var speed: float = 15.0
@export var fade_duration: float = 0.8

var is_landing: bool = true
var tween: Tween
var tween2: Tween
var tween3: Tween

func _ready():
	if not ship or not cinematic_camera or not landing_point or not player:
		push_error("Настрой экспортные переменные в SceneController!")
		return

	player.process_mode = PROCESS_MODE_DISABLED  # отключаем игрока до конца заставки
	cinematic_camera.current = true  # делаем камеру активной

	tween = create_tween()
	tween.bind_node(self)

	# Запускаем анимацию посадки
	var start_pos = ship.global_transform.origin
	var target_pos = landing_point.global_transform.origin

	var distance = (start_pos - target_pos).length()
	var duration = distance / speed

	tween.tween_property(ship, "global_transform:origin", target_pos, duration)
#	tween.set_trans(Tween.TRANS_LINEAR)
#	tween.set_ease(Tween.EASE_IN_OUT)
#	tween.start()

	tween.finished.connect(_on_landing_finished)

func _on_landing_finished():
	is_landing = false
	# Здесь можно добавить звук приземления, частицы и т.п.
	_start_gameplay()

func _start_gameplay():
	# Плавно переключаем камеру — можно просто сделать другую активной
	# Вариант 1: сразу активировать камеру игрока (если у него есть SpringArm+Camera)
	# Вариант 2: двигать CinematicCamera к позиции игрока

	var player_pos = player.global_transform.origin
#	var camera_target_pos = Vector3(player_pos.x, player_pos.y + 5, player_pos.z - 8)  # пример позиции
	var player_camera = player.cam
#	var camera_target_pos = Vector3(player_pos.x, player_pos.y + 5, player_pos.z - 8)  # пример позиции
	var camera_target_pos = player_camera.global_position  # пример позиции
	print(camera_target_pos)
	var move_duration = 1.5
	
	tween3 = create_tween()
#	cinematic_camera.rotate_x()
	tween3.tween_property(cinematic_camera, "rotation:x", 0, move_duration)
	await get_tree().create_timer(move_duration).timeout
	
	tween2 = create_tween()
	tween2.tween_property(cinematic_camera, "global_position", camera_target_pos, move_duration)
#	tween.set_trans(Tween.TRANS_QUAD)
#	tween.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(move_duration).timeout
	player_camera.current = true
	player.process_mode = Node.PROCESS_MODE_INHERIT
	# Если у игрока своя камера — активируй её, а cinematic_camera можно отключить
	# cinematic_camera.current = false

