extends Area3D



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	$SpotLight3D.visible = true
	$"../../CharacterBody3D".msg("Надо взять костюм")


func _on_mouse_exited():
	$SpotLight3D.visible = false

@export var inv_name = ""
func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		Game.inventory.append(inv_name)
		print(Game.inventory)
		queue_free()
