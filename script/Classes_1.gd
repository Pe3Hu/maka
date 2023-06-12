extends Node


#Стадиом stadion
class Stadion:
	var arr = {}
	var obj = {}
	var num = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.index = Global.num.index.stadion
		Global.num.index.stadion += 1
		obj.wettbewerb = input_.wettbewerb
		obj.winner = null
		arr.mannschaft = input_.mannschafts
		init_scene()
		
		for mannschaft in arr.mannschaft:
			mannschaft.set_opponent()


	func init_scene() -> void:
		scene.myself = Global.scene.stadion.instantiate()
		scene.myself.set_parent(self)
		obj.wettbewerb.scene.myself.get_node("Stadion").add_child(scene.myself)


	func make_deal() -> void:
		scene.myself.update_color()
		
		for mannschaft in arr.mannschaft:
			for challenger in mannschaft.obj.trainerin.arr.challenger:
				challenger.obj.croupier.pull_standard_spielkartes()
			
			mannschaft.obj.trainerin.start_combo()


	func clean_out() -> void:
		for mannschaft in arr.mannschaft:
			for challenger in mannschaft.obj.trainerin.arr.challenger:
				challenger.obj.croupier.reset_section("dream")


	func close() -> void:
		for croupier in arr.croupier:
			croupier.reset_after_stadion()
		
		scene.myself.claer_after_close()


#Турнир wettbewerb
class Wettbewerb:
	var arr = {}
	var num = {}
	var obj = {}
	var dict = {}
	var flag = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.turn = {}
		num.turn.current = 0
		obj.sport = input_.sport
		word.type = input_.type
		dict.mannschaft = {}
		flag.end = false
		flag.pause = false
		
		for mannschaft in input_.mannschafts:
			mannschaft.obj.wettbewerb = self
			dict.mannschaft[mannschaft] = []
		
		init_scene()
		set_phases_by_wettbewerb()
		init_standings()
		next_round()


	func init_scene() -> void:
		scene.myself = Global.scene.wettbewerb.instantiate()
		scene.myself.set_parent(self)
		obj.sport.scene.myself.get_node("Wettbewerb").add_child(scene.myself)


	func init_standings() -> void:
		num.challengers = dict.mannschaft.keys().size()
		dict.standings = {}
		num.round = {}
		num.round.current = 0
		num.round.last = num.challengers - 1
		num.turn.current = 0
		set_order()
		
		for round in num.round.last:
			dict.standings[round] = []
			
			for _i in num.challengers:
				var _j = (_i + 1 + round + num.challengers) % num.challengers
				var pair = [_i, _j]
				dict.standings[round].append(pair)


	func set_order() -> void:
		var orders = []
		orders.append_array(Global.dict.credo.keys())
		
		for mannschaft in dict.mannschaft.keys():
			for athleten in dict.mannschaft[mannschaft]:
				athleten.num.order = orders.find(athleten.word.credo)


	func next_round() -> void:
		if num.round.current < num.round.last:
			flag.end = false
			print("round ", num.round.current)
			init_stadions()
			scene.myself.call_follow_phase()
			#make_stadion_deals()
			num.round.current += 1


	func init_stadions() -> void:
		arr.stadion = []
		scene.myself.remove_all_stadion()
		
		for pair in dict.standings[num.round.current]:
			var input = {}
			input.wettbewerb = self
			input.mannschafts = []
			
			for _i in pair.size():
				var mannschaft = dict.mannschaft.keys()[_i]
				var _j = pair[_i]
				input.mannschafts.append(mannschaft)
				mannschaft = dict.mannschaft.keys()[_j]
				input.mannschafts.append(mannschaft)
			
			var stadion = Classes_1.Stadion.new(input)
			arr.stadion.append(stadion)


	func make_stadion_deals() -> void:
		while !flag.end && num.turn.current < 200:
			scene.myself.call_follow_phase()


	func set_phases_by_wettbewerb() -> void:
		arr.phase = []
		
		match word.type:
			"standart":
				arr.phase.append("clean out")
				arr.phase.append("make deal")
				arr.phase.append("athleten queue")
		
		num.turn.current += 1


	func check_end() -> void:
		flag.end = arr.stadion.size() == 0
		
		if flag.end:
			show_score()
			next_round()


	func show_score() -> void:
		var mannschafts = {}
		
		for mannschaft in dict.mannschaft.keys():
			mannschafts[mannschaft] = {}
			
			for athleten in dict.mannschaft[mannschaft]:
				mannschafts[mannschaft][athleten.word.credo] = athleten.num.score
		
			print(mannschafts[mannschaft])


	func pause() -> void:
		flag.pause = !flag.pause
		scene.myself.follow_phase()
