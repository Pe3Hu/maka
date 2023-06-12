extends MarginContainer


var parent = null
var tween = null


func set_parent(parent_) -> void:
	parent = parent_
	set_mannschafts()
	update_color()


func set_mannschafts() -> void:
	for mannschaft in parent.arr.mannschaft:
		mannschaft.obj.stadion = parent
		mannschaft.obj.trainerin.scene.myself.put_challengers_on_the_stadion()
		$VBox.add_child(mannschaft.obj.trainerin.scene.myself)


func update_color() -> void:
	var max_h = 360.0
	var h = float(parent.num.index)/Global.num.index.stadion
	var s = 0.75
	var v = 0.5
	
	var color_ = Color.from_hsv(h, s, v)
	$BG.set_color(color_)


func follow_phase() -> void:
	if parent.obj.winner == null:
		var time = 0.05
		tween = create_tween()
		tween.tween_property(self, "position", 0, time)
		tween.tween_callback(call_follow_phase)


func call_follow_phase() -> void:
	var phase = parent.obj.wettbewerb.arr.phase.front()
	var words = phase.split(" ")
	var func_name = ""
	
	for _i in words.size():
		var word = words[_i]
		func_name += word
		
		if _i != words.size()-1:
			func_name += "_"
	
	Callable(parent, func_name).call()


func claer_after_close() -> void:
	var node = $VBox
	
	while node.get_child_count() > 0:
		var child = node.get_children().pop_front()
		node.remove_child(child)
	
	parent.obj.abroller.scene.myself.queue_free()
	parent.obj.abroller.obj.stadion = null
	parent.obj.wettbewerb.arr.stadion.erase(parent)
	parent.obj.wettbewerb.check_end()
	queue_free()
