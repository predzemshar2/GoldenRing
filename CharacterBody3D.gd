extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var PanelInventory = $Camera3D/CanvasLayer/PanelInventory

func _ready()->void:
#	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	$Camera3D/CanvasLayer/Label.text=""
	
var sensitivity = 0.005  # Чувствительность мыши
@onready var camera = $Camera3D
func _input(event):
	if event is InputEventMouseMotion:
		# Поворачиваем голову персонажа (вокруг оси Y)
		$".".rotate_y(-event.relative.x * sensitivity)
		
		# Поворачиваем камеру (вокруг её локальной оси X)
		camera.rotate_x(-event.relative.y * sensitivity)
		
		# Ограничиваем угол наклона камеры, чтобы не было переворота
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_F1:
				_on_texture_button_pressed()
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
func msg(text):
	$Camera3D/CanvasLayer/Label.modulate.a=1
	$Camera3D/CanvasLayer/Label.text=text
	create_tween().tween_property($Camera3D/CanvasLayer/Label,"modulate:a",0,2)


func _on_texture_button_pressed():
	PanelInventory.visible = not PanelInventory.visible 
