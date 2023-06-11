extends Node


#Тренер trainerin
class Trainerin:
	var arr = {}
	var obj = {}
	var num = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.mannschaft = input_.mannschaft
		arr.challenger = []
		init_scene()


	func init_scene() -> void:
		scene.myself = Global.scene.trainerin.instantiate()
		scene.myself.set_parent(self)


	func set_challengers() -> void:
		for athleten in obj.mannschaft.arr.athleten:
			arr.challenger.append(athleten)


#Команда mannschaft
class Mannschaft:
	var arr = {}
	var obj = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.sport = input_.sport
		obj.wettbewerb = null
		init_trainerin()
		init_athletens()
		set_basic_scherbes()
		#suit_up_basic_scherbes()
		obj.trainerin.set_challengers()
		dict.match_history = {}


	func init_trainerin() -> void:
		var input = {}
		input.mannschaft = self
		obj.trainerin = Classes_0.Trainerin.new(input)


	func init_athletens() -> void:
		arr.athleten = []
		var n = 1
		
		for credo in Global.dict.credo.title.keys():
			var input = {}
			input.mannschaft = self
			input.credo = credo
			var athleten = Classes_2.Athleten.new(input)
			arr.athleten.append(athleten)


	func set_basic_scherbes() -> void:
		dict.scherbe = {}
		
		for wind_rose in Global.arr.wind_rose:
			dict.scherbe[wind_rose] = []
		
		for _i in arr.athleten.size()+1:
			for wind_rose in Global.arr.wind_rose:
				var input = {}
				input.wind_rose = wind_rose
				input.polyhedron = 3
				var scherbe = Classes_3.Scherbe.new(input)
				dict.scherbe[wind_rose].append(scherbe)


	func suit_up_basic_scherbes() -> void:
		var athletens = []
		athletens.append_array(arr.athleten)
		athletens.shuffle()
		
		while athletens.size() > 0:
			var athleten = athletens.pop_front()
			athleten.obj.mönch.choose_best_outfit()


	func get_free_scherbes() -> void:
		for wind_rose in dict.scherbe:
			var free_scherbes = []
			
			for scherbe in dict.scherbe[wind_rose]:
				if scherbe.obj.achteck == null:
					free_scherbes.append(scherbe)


	func set_opponent() -> void:
		if obj.wettbewerb != null:
			var opponents = []
			opponents.append_array(obj.wettbewerb.dict.mannschaft.keys())
			opponents.erase(self)
			obj.opponent = opponents.front()
			dict.match_history[obj.opponent] = 0
		else:
			print("#error 0# Spieler -> set_opponent")


#Спорт sport
class Sport:
	var arr = {}
	var obj = {}
	var scene = {}


	func _init() -> void:
		init_scene()
		init_mannschafts()
		arr.wettbewerb = []
		
		var mannschafts = []
		mannschafts.append_array(arr.mannschaft)
		add_wettbewerb(mannschafts)


	func init_scene() -> void:
		scene.myself = Global.scene.sport.instantiate()
		Global.node.game.get_node("Layer0").add_child(scene.myself)


	func init_mannschafts() -> void:
		arr.mannschaft = []
		var n = 2
		
		for _i in n:
			var input = {}
			input.sport = self
			var mannschaft = Classes_0.Mannschaft.new(input)
			arr.mannschaft.append(mannschaft)


	func add_wettbewerb(mannschafts_: Array) -> void:
		var input = {}
		input.sport = self
		input.type = "standart"
		input.mannschafts = mannschafts_
		var wettbewerb = Classes_1.Wettbewerb.new(input)
		arr.wettbewerb.append(wettbewerb)

