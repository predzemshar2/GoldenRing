extends CharacterBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var PanelInventory = $Camera3D/CanvasLayer/PanelInventory
@onready var PanelMap = $Camera3D/CanvasLayer/PanelMap
@onready var PanelGoals = $Camera3D/CanvasLayer/PanelGoals
@onready var cam = $Camera3D
func _ready()->void:
#	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	$Camera3D/CanvasLayer/Label.text=""
	PanelInventory.visible=false
	PanelMap.visible=false
	PanelGoals.visible=false
	Game.taked.connect(_on_take)
	Game.completed.connect(_on_complete)
	Game.quest_completed.connect(_on_complete_quest)
	if Game.inventory.has("clothes"):
		_on_clothes()
	Game.visited.connect(_on_visit )
	$Camera3D/CanvasLayer/MapTextureButton2.visible=Game.inventory.has("map")
var sensitivity = 0.005  # Чувствительность мыши
@onready var camera = $Camera3D
func _on_complete_quest(loc_name):
	$AudioStreamPlayer3D_complete_quest.play()
func _on_complete(loc_name):
	print("_on_complete:",loc_name)
	$AudioStreamPlayer3D.play()
func _on_visit(loc_name):
	print("visit:",loc_name)
func _on_clothes():
	$Camera3D/CanvasLayer/InoAnimatedSprite2D.animation="clothes"
func _on_take(inv_name):
	print("take:",inv_name)
	$AudioStreamPlayer3D_take.play()
	if inv_name=="clothes":
		_on_clothes()
	if inv_name=="map":
		$Camera3D/CanvasLayer/MapTextureButton2.visible=true
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
			if event.keycode == KEY_F2:
				_on_map_texture_button_2_pressed()
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
#		if velocity.x>0:
	var camera_position = $Camera3D.global_position
	var camera_forward = -$Camera3D.global_transform.basis.z
	var camera_point_1m_ahead = camera_position + camera_forward *5
	
	Game.marker_for_robot = camera_point_1m_ahead 
#	Game.marker_for_robot = $Camera3D/Marker3D.global_position

	move_and_slide()
func msg(text):
	$Camera3D/CanvasLayer/Label.modulate.a=1
	$Camera3D/CanvasLayer/Label.text=text
	create_tween().tween_property($Camera3D/CanvasLayer/Label,"modulate:a",0,4)


func _on_texture_button_pressed():
	var i=0
	for btn in $Camera3D/CanvasLayer/PanelInventory/GridContainer.get_children():
		if i>= Game.inventory.size():
			btn.visible=false
		else:
			btn.text = Game.descriptions[ Game.inventory[i]]["name"]
			btn.visible=true
			i+=1
	PanelInventory.visible = not PanelInventory.visible 


func _on_map_texture_button_2_pressed():
	if Game.inventory.has("map"):
		PanelMap.visible = not PanelMap.visible 
	if Game.locations.has("zap_yar"):
		$"Camera3D/CanvasLayer/PanelMap/ControlLocations/ButtonYar'".icon=load("res://icons/check.png")
	if Game.locations.has("him_mash"):
		$Camera3D/CanvasLayer/PanelMap/ControlLocations/ButtonSergiev.icon=load("res://icons/check.png")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://location.tscn")


func _on_goals_texture_button_3_pressed():
	var i=0
	for btn in $Camera3D/CanvasLayer/PanelGoals/VBoxContainer.get_children():
		if i>= Game.goals.size():
			btn.visible=false
		else:
			btn.text = Game.goal_descriptions[ Game.goals[i]]["name"]
			btn.visible=true
			if Game.goals_completed.has(Game.goals[i]):
				btn.icon=load("res://icons/check.png")
			else:
				btn.icon=null
			i+=1
	PanelGoals.visible = not PanelGoals.visible 


func _on_button_sergiev_pressed():
	get_tree().change_scene_to_file("res://location_sergiev.tscn")
