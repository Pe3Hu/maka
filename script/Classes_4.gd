extends Node


#Крупье croupier
class Croupier:
	var num = {}
	var obj = {}
	var dict = {}
	var flag = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.draw = {}
		num.draw.total = input_.draw
		num.draw.current = num.draw.total
		obj.athleten = input_.athleten
		obj.stadion = null
		dict.out = {}
		init_scene()
		init_album()


	func init_scene() -> void:
		scene.myself = Global.scene.croupier.instantiate()
		scene.myself.set_parent(self)


	func init_album() -> void:
		var input = {}
		input.croupier = self
		obj.album = Classes_5.Album.new(input)


	func pull_standard_spielkartes():
		obj.album.fill_thought()
		
		#for _i in range(obj.album.arr.spielkarte.thought.size()-1, -1, -1):
		#	var spielkarte = obj.album.arr.spielkarte.thought[_i]
		#	obj.album.convert_thought_into_dream(spielkarte)
		
		obj.athleten.arr.phase.pop_front()


	func calc_chance_of_losing() -> Dictionary:
		var outcomes = {}
		outcomes.good = 0
		outcomes.bad = 0
		
		for rank in dict.out.keys():
			if rank + num.harmony > Global.num.spielkarte.rank.white_skin:
				outcomes.bad += dict.out[rank].size()
			else:
				outcomes.good += dict.out[rank].size()
		
		return outcomes


	func reset_section(section_: String) -> void:
		obj.album.pull_full_section(section_)
		scene.myself.remove_spielkartes_from(section_)


	func reset_after_stadion() -> void:
		obj.athleten.num.score += obj.athleten.dict.match_history[obj.athleten.obj.opponent]
		obj.stadion = null
		obj.athleten.obj.opponent = null
		obj.album.full_reset()
		obj.athleten.obj.athleten.obj.mönch.obj.achteck.reset_main_aspects()
		obj.athleten.obj.athleten.obj.anzeige.scene.myself.reset_aspects()
		scene.myself.reset_spielkartes()
