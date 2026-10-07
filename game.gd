
class_name game extends Node

var marker_for_robot: Vector3
var inventory =[]
var locations =[]
var cur_location =""
var goals =[]
var goals_completed =[]
var quests_completed =[]

var descriptions ={
	"clothes":{
		"id":1,
		"name":"Одежда",
		"description":"  нужна для маскировки",
		"icon":"",
		"-":"",
	},
	"map":{
		"id":2,
		"name":"Карта",
		"description":"Нужна для перемещения в другие локации",
		"icon":"",
		"-":"",
	},	
	"tank":{
		"id":2,
		"name":"Топливный бак",
		"description":"Нужен для топлива",
		"icon":"",
		"-":"",
	},
	"planet":{
		"id":3,
		"name":"Схема солнечной системы",
		"description":"Нужна для навигации в космосе",
		"icon":"",
		"-":"",
	}
}
var location_descriptions ={
	"zap_yar":{
		"id":1,
		"name":"Заповедник Ярославский",
		"description":"Основные цели заказника — сохранение и воспроизводство ценных  охотничьих животных! Следуй по указателю",
		"icon":"",
		"-":"",
	},
	"him_mash":{
		"id":2,
		"name":"Текса Химмаш в городе Сергиев Посад",
		"description":"это научно-производственная организация, которая специализируется на производстве оборудования для химической промышленности",
		"icon":"",
		"-":"",
	},
	"plan_vlad":{
		"id":3,
		"name":"Владимирский Планетарий",
		"description":"Планетарий для приёма посетителей с множеством космических экспонатов",
		"icon":"",
		"-":"",
	}
}
var quests ={
	"zap_yar":{
		"id":1,
		"name":"Викторина заповедника Ярославский",
		"description":"Голос какой птицы вы слышите?",
		"icon":"",
		"options":["Зяблик","Малиновка","Жаворонок "], # 0,1 or 2
		"right":1,
	},
	"him_mash":{
		"id":2,
		"name":"Викторина Тексы",
		"description":"Какую продукцию выпускает Текса",
		"icon":"",
		"options":["Стройматериалы","Металлургическую","Хим.продукцию"], # 0,1 or 2
		"right":2,
	},
	"plan_vlad":{
		"id":3,
		"name":"Викторина Планетария",
		"description":"Какая планета 5-я по счёту от солнца?",
		"icon":"",
		"options":["Венера","Сатурн","Юпитер"], # 0,1 or 2
		"right":2,
	},
}
var goal_descriptions ={
	"zap_yar":{
		"id":1,
		"name":"Посетить Заповедник Ярославский! Нужна одежда, карта и узнать информацию",
		"description":"Нам нужна одежда, карта и узнать информацию! Используй щелчок мыши на предметах! ",
		"icon":"",
		"need":["map","clothes"],
	},
	"him_mash":{
		"id":2,
		"name":"Посетить Текса Химмаш в городе Сергиев Посад!",
		"description":" Здась мы сможем раздобыть топливный бак и получить больще информации",
		"icon":"",
		"need":["tank"],
	},
	"plan_vlad":{
		"id":3,
		"name":"Посетить Владимирский Планетарий в городе Владимир!",
		"description":" Здась мы сможем изучить Солнечную систему и узнать об этом месте",
		"icon":"",
		"need":["planet"],
	}
}
signal taked(inv_name)
signal completed(loc_name)
signal quest_completed(loc_name)
signal visited(loc_name)
signal take_goal(loc_name)
# Called when the node enters the scene tree for the first time.
#@onready var voices = DisplayServer.tts_get_voices_for_language("ru")


func quest_complete(loc_name):
	quests_completed.append(loc_name)
	quest_completed.emit(loc_name)


func take(inv_name):
	inventory.append(inv_name)
	speak("Капитан! Получен предмет " + descriptions[inv_name]["name"] + " " + descriptions[inv_name]["description"])
	taked.emit(inv_name)
	check_completed()


func visit(loc_name):
	locations.append(loc_name)
	speak("Капитан! Мы посещаем " + location_descriptions[loc_name]["name"] ) #+ " " + location_descriptions[loc_name]["description"])
	visited.emit(loc_name)
	if not goals.has(loc_name):
		goals.append(loc_name)
		take_goal.emit()
		_on_new_goal()


func _on_new_goal():
	speak("Получена новая цель: ")
#	 +goal_descriptions[cur_location]["name"]+" "+goal_descriptions[cur_location]["description"])


func check_completed():
	var x = true
	for g in goal_descriptions[cur_location]["need"]:
		x = x and inventory.has(g)
	x = x and quests_completed.has(cur_location)
	if x:
		goals_completed.append(cur_location)
		speak("Отлично!  Мы прошли локацию, выберите на карте следующую (нажми ф 2)")
		completed.emit(cur_location)


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
