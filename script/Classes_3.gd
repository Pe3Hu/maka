extends Node


#Осколок scherbe
class Scherbe:
	var arr = {}
	var num = {}
	var obj = {}
	var word = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.polyhedron = input_.polyhedron
		word.wind_rose = input_.wind_rose
		obj.achteck = null
		init_stat()


	func init_stat() -> void:
		dict.stat = {}
		var category = {}
		category.primary = 1
		var limit = Global.dict.scherbe.polyhedron[num.polyhedron]
		Global.rng.randomize()
		category.secondary = Global.rng.randi_range(limit.min, limit.max)
		
		for key in category.keys():
			for _i in category[key]:
				roll_stat(key)


	func roll_stat(category_: String) -> void:
		var aspects = {}
		var types = []
		
		match category_:
			"primary":
				types = ["bonus"]
				aspects = Global.dict.scherbe.group[word.wind_rose]
			"secondary":
				types = Global.arr.type
				
				for aspect in Global.arr.aspect:
					aspects[aspect] = 1
		
		var datas = {}
		
		for aspect in aspects.keys():
			for type in types:
				var data = {}
				data.aspect = aspect
				data.type = type
				var flag = true
				
				if dict.stat.has(aspect):
					if dict.stat[aspect].has(type):
						flag = false
				
				if flag:
					datas[data] = aspects[aspect]
		
		var data = Global.get_random_key(datas)
		
		if !dict.stat.keys().has(data.aspect):
			dict.stat[data.aspect] = {}
		
		dict.stat[data.aspect][data.type] = {}
		var limit = Global.dict.octagon[data.aspect][data.type][category_]
		Global.rng.randomize()
		var value = null
		
		match data.type:
			"bonus":
				value = Global.rng.randi_range(limit.min, limit.max)
			"multiplier":
				value = Global.rng.randi_range(limit.min * 10, limit.max * 10)
				value = float(value)/10.0
				
		dict.stat[data.aspect][data.type][category_] = value


#Восьмиугольник achteck 
class Achteck:
	var arr = {}
	var obj = {}
	var num = {}
	var flag = {}
	var dict = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		obj.athleten = input_.athleten
		flag.alive = true
		init_aspect()
		init_scherbe_slots()


	func init_aspect() -> void:
		num.aspect = {}
		
		for aspect in Global.arr.aspect:
			num.aspect[aspect] = {}
			num.aspect[aspect].base = Global.dict.stat.base[aspect]
			num.aspect[aspect].primary = 0
			num.aspect[aspect].secondary = 0
			num.aspect[aspect].multiplier = 0
			num.aspect[aspect].result = 0
			num.aspect[aspect].current = 0


	func init_scherbe_slots() -> void:
		dict.scherbe = {}
		
		for wind_rose in Global.arr.wind_rose:
			dict.scherbe[wind_rose] = null


	func suit_up_scherbe(scherbe_: Scherbe) -> void:
		take_off_scherbe(scherbe_.word.wind_rose)
		dict.scherbe[scherbe_.word.wind_rose] = scherbe_
		scherbe_.obj.achteck = self
		amend_stats_by_scherbe(scherbe_, 1)


	func take_off_scherbe(wind_rose_: String) -> void:
		if dict.scherbe[wind_rose_] != null:
			amend_stats_by_scherbe(dict.scherbe[wind_rose_], -1)
			dict.scherbe[wind_rose_].obj.achteck = null
			dict.scherbe[wind_rose_] = null


	func amend_stats_by_scherbe(scherbe_: Scherbe, sign: int) -> void:
		for aspect in scherbe_.dict.stat.keys():
			for type in scherbe_.dict.stat[aspect].keys():
				for category in scherbe_.dict.stat[aspect][type].keys():
					var value = scherbe_.dict.stat[aspect][type][category]
					
					match type:
						"bonus":
							num.aspect[aspect][category] += value * sign
						"multiplier":
							num.aspect[aspect].multiplier += value * 0.01 * sign


	func update_aspects() -> void:
		for aspect in Global.arr.auxiliary:
			formula_stat(aspect)
		
		for aspect in Global.arr.main:
			formula_stat(aspect)
		
		reset_main_aspects()


	func formula_stat(aspect_: String) -> void:
		var stat = num.aspect[aspect_]
		var sign = 1
		
		if aspect_ == "rage":
			sign = -1
		
		stat.result = (stat.base + sign * stat.primary) * (1 + sign * stat.multiplier) + sign * stat.secondary
		
		if Global.arr.main.has(aspect_):
			for auxiliary in Global.dict.scherbe.auxiliary[aspect_]:
				stat.result += sign * num.aspect[auxiliary].result * Global.num.aspect.synergy.auxiliary
		
		if aspect_ == "rage":
			stat.result = max(Global.num.stat.min.rage, stat.result)
		
		stat.result = ceil(stat.result)


	func reset_main_aspects():
		flag.alive = true
		
		for aspect in num.aspect.keys():
			num.aspect[aspect].current = num.aspect[aspect].result


	func change_aspect(aspect_: String, changes_: int) -> void:
		if flag.alive:
			num.aspect[aspect_].current += changes_
			num.aspect[aspect_].current = min(num.aspect[aspect_].current, num.aspect[aspect_].result)
			num.aspect[aspect_].current = max(num.aspect[aspect_].current, 0)
			#print(obj.mönch.obj.athleten.obj.spieler.num.index, " > ", num.aspect[aspect_].current)
			
			#Global.num.index.etikett += 1
			#print(Global.num.index.etikett, " > ", num.aspect[aspect_].current)
			if aspect_ == "health" and num.aspect[aspect_].current == 0:
				score_loss()


	func score_loss() -> void:
		flag.alive = false
		var spieler = obj.mönch.obj.athleten.obj.spieler
		var a = spieler.obj.croupier.obj
		spieler.obj.croupier.obj.stadion.obj.winner = spieler.obj.opponent
		spieler.obj.opponent.dict.match_history[spieler] = Global.num.score.win
		spieler.dict.match_history[spieler.obj.opponent] = Global.num.score.loss
		spieler.obj.croupier.obj.stadion.close_table()
