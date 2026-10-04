extends Area3D

@export var inv_name = ""
@export var must_delete = true
var description=""
# Called when the node enters the scene tree for the first time.
func _ready():
	if  Game.descriptions[inv_name]:
		description = Game.descriptions[inv_name]["name"]
		description += "\n" + Game.descriptions[inv_name]["description"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	$SpotLight3D.visible = true
	$"../../CharacterBody3D".msg(description)


func _on_mouse_exited():
	$SpotLight3D.visible = false


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if not Game.inventory.has(inv_name):
			Game.inventory.append(inv_name)
			print(Game.inventory)
			if must_delete:
				queue_free()
