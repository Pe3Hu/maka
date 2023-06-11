extends MarginContainer


var parent = null
var tween = null


func set_parent(parent_) -> void:
	parent = parent_


func remove_all_stadion():
	while $Stadion.get_child_count() > 0:
		var child = $Stadion.get_children().pop_front()
		$Stadion.remove_child(child)


func follow_phase() -> void:
	if !parent.flag.end && !parent.flag.pause:
		var time = 0.05
		tween = create_tween()
		tween.tween_property(self, "position", Vector2(), time)
		tween.tween_callback(call_follow_phase)


func call_follow_phase() -> void:
	var phase = parent.arr.phase.pop_front()
	var words = phase.split(" ")
	var func_name = ""
	
	for _i in words.size():
		var word = words[_i]
		func_name += word
		
		if _i != words.size()-1:
			func_name += "_"
	
	for stadion in parent.arr.stadion:
		Callable(stadion, func_name).call()
		
	if parent.arr.phase.size() == 0:
		parent.set_phases_by_wettbewerb()
	
	
	if phase == "make deal":
		parent.flag.pause = true
	
	if !parent.flag.pause:
		follow_phase()
