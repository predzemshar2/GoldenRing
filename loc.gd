extends Area3D

@export var loc_name = ""
@export var must_delete = false
var description=""
var speaked = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Game.cur_location=loc_name
	if  Game.location_descriptions[loc_name]:
		description = Game.location_descriptions[loc_name]["name"]
		description += "\n" + Game.location_descriptions[loc_name]["description"]
		Game.visit(loc_name)
#	if  not Game.locations.has(loc_name):
#		Game.speak("Капитан! Получена новая цель: " +Game.goal_descriptions[loc_name]["name"] +Game.goal_descriptions[loc_name]["description"] )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	print(loc_name)
	$"../../CharacterBody3D".msg(description)
	if not speaked:
		speaked=true
		Game.speak(Game.location_descriptions[loc_name]["description"])


func _on_mouse_exited():
#	$SpotLight3D.visible = false
	pass


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if not Game.locations.has(loc_name):
			Game.visit(loc_name)
			print(Game.locations)
			if must_delete:
				queue_free()

