extends Node


func _ready() -> void:
	Global.obj.sport = Classes_0.Sport.new()
	#datas.sort_custom(func(a, b): return a.value < b.value) 
	#012

func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					Global.obj.kasino.arr.wettbewerb.front().next_phase()
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					Global.obj.kasino.arr.wettbewerb.front().pause()#make_spieltisch_deals()


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
	
#					obj.album.pull_spielkarte_from_archive()
#					var spielkarte = obj.album.arr.spielkarte.thought.front()
#					obj.album.convert_thought_into_dream(spielkarte)

