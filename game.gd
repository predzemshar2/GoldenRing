
class_name game extends Node

var inventory =[]
var goals =[]
var descriptions ={
	"clothes":{
		"id":1,
		"name":"Одежда",
		"description":"Одежда нужна для маскировки",
		"icon":"",
		"-":"",
	},
	"map":{
		"id":2,
		"name":"Карта",
		"description":"Нужна для перемещения в другие локации",
		"icon":"",
		"-":"",
	}
}

# Called when the node enters the scene tree for the first time.
#@onready var voices = DisplayServer.tts_get_voices_for_language("ru")
func _ready():
	pass
#	print(voices)
	
func speak(text):
	var voices = DisplayServer.tts_get_voices_for_language("ru")
	print(voices)
	if voices.size() > 0:
		var voice_id = voices[0]
		print(voice_id)
		# volume: 0-100, pitch: 0.0-2.0, rate: 0.1-10.0, utterance_id: int, interrupt: bool
		DisplayServer.tts_speak(text, voice_id, 50, 1.0, 1.0, 0, false)
	else:
		print("Русские голоса не найдены")
