extends Node


#Атлет athleten
class Athleten:
	var arr = {}
	var obj = {}
	var num = {}
	var word = {}
	var scene = {}


	func _init(input_: Dictionary) -> void:
		num.index = Global.num.index.athleten
		Global.num.index.athleten += 1
		obj.mannschaft = input_.mannschaft
		word.credo = input_.credo
		obj.wettbewerb = null
		init_achteck()
		init_croupier()


	func init_scene() -> void:
		scene.myself = Global.scene.athleten.instantiate()
		scene.myself.set_parent(self)
		obj.mannschaft.scene.myself.get_node("Athleten").add_child(scene.myself)


	func init_credo() -> void:
		word.credo = "jester"#Global.get_random_element(Global.dict.credo.keys())


	func init_achteck() -> void:
		var input = {}
		input.athleten = self
		obj.achteck = Classes_3.Achteck.new(input)


	func init_croupier() -> void:
		var input = {}
		input.draw = 2
		input.athleten = self
		obj.croupier = Classes_4.Croupier.new(input)


	func choose_best_outfit() -> void:
		var priority = Global.dict.credo.title[obj.athleten.word.credo]
		var aspects = []
		aspects.append(priority.main)
		aspects.append(priority.auxiliary)
		
		for wind_rose in obj.achteck.dict.scherbe.keys():
			var datas = []
			
			for scherbe in obj.athleten.obj.mannschaft.dict.scherbe[wind_rose]:
				if scherbe.obj.achteck == null:
					var data = {}
					data.scherbe = scherbe
					data.weight = 0
					
					for aspect in scherbe.dict.stat.keys():
						if aspects.has(aspect):
							for type in scherbe.dict.stat[aspect].keys(): 
								for category in scherbe.dict.stat[aspect][type].keys(): 
									data.weight += Global.num.weight.scherbe[type][category]
					
					datas.append(data)
			
			datas.sort_custom(func(a, b): return a.weight > b.weight)
			var options = []
			
			for data in datas:
				if data.weight == datas.front().weight:
					options.append(data.scherbe)
			
			var scherbe = Global.get_random_element(options)
			obj.achteck.suit_up_scherbe(scherbe)
		
		obj.achteck.update_aspects()
