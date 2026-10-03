extends Node3D

var a=0
var r



# Called when the node enters the scene tree for the first time.
func _ready():
	r = $Mercury.global_position.x
	print("Orbit: ",r)

	var tween = create_tween()
	tween.tween_property($CanvasLayer/Label,"modulate:a",0,5)
#	connect("input_event", self, "on_input_event)


func _process(delta):
	a = a+ delta
	$Mercury.global_position = Vector3(r*sin(a),0,r*cos(a))
	$Sun.rotate_y(delta/10)


func _on_area_3d_mouse_entered():
	$CanvasLayer/Label.modulate.a =1
	$CanvasLayer/Label.text = "Планета Земля.\n Выберите, чтобы приземлиться"


func _on_area_3d_mouse_exited():
	$CanvasLayer/Label.text =""


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		print("click")
		get_tree().change_scene_to_file("res://location.tscn")
