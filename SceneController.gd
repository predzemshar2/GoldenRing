extends Node3D

@export var ship: Node3D
@export var cinematic_camera: Camera3D
@export var landing_point: Marker3D
@export var player: CharacterBody3D

@export var speed: float = 30.0
@export var fade_duration: float = 0.8

var is_landing: bool = true
var tween: Tween
var tween2: Tween
var tween3: Tween
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_SPACE:
				if tween:
					tween.stop()
				if tween2:
					tween2.stop()
				if tween3:
					tween3.stop()
				_on_landing_finished()
func _ready():
	if not ship or not cinematic_camera or not landing_point or not player:
		push_error("Настрой экспортные переменные в SceneController!")
		return
#	Game.speak("Приветики, земляне!")
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

	await get_tree().create_timer(duration).timeout
	
	var player_pos = player.global_transform.origin
	var player_camera = player.cam
	var camera_target_pos = player_camera.global_position  # пример позиции
	print(camera_target_pos)
	var move_duration = 1.5
	
	tween3 = create_tween()
	tween3.tween_property(cinematic_camera, "rotation:x", 0, move_duration)
	await get_tree().create_timer(move_duration).timeout
	
	tween2 = create_tween()
	tween2.tween_property(cinematic_camera, "global_position", camera_target_pos, move_duration)
	tween2.finished.connect(_on_landing_finished)
#	await get_tree().create_timer(move_duration).timeout


func _on_landing_finished():
	is_landing = false
	# Здесь можно добавить звук приземления, частицы и т.п.
	_start_gameplay()

func _start_gameplay():
	var player_camera = player.cam
	player_camera.current = true
	player.process_mode = Node.PROCESS_MODE_INHERIT
	queue_free()

