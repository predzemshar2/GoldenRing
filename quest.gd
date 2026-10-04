extends Area3D


var description=""
@export var option = 0
@export var speaked = false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	description = Game.quests[Game.cur_location]["description"]
	
	
#	if  Game.location_descriptions[loc_name]:
#		description += "\n" + Game.location_descriptions[loc_name]["description"]
#		Game.visit(loc_name)
#	if  not Game.locations.has(loc_name):
#		Game.speak("Капитан! Получена новая цель: " +Game.goal_descriptions[loc_name]["name"] +Game.goal_descriptions[loc_name]["description"] )
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_mouse_entered():

	$"../../CharacterBody3D".msg(description + "\n" + Game.quests[Game.cur_location]["options"][option])
	if not Game.quests_completed.has(Game.cur_location):
		if not speaked:
			speaked=true
			Game.speak(description)


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if not Game.quests_completed.has(Game.cur_location):
			Game.quest_complete(Game.cur_location)
			print("quests_completed:",Game.quests_completed)
			if option == Game.quests[Game.cur_location]["right"]:
				Game.speak("Верно")
			else:
				Game.speak("Неверно")
			Game.check_completed()



func _on_mouse_exited():
	pass # Replace with function body.
