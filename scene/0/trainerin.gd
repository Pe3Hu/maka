extends MarginContainer


var parent = null


func set_parent(parent_) -> void:
	parent = parent_


func put_challengers_on_the_stadion() -> void:
	for challenger in parent.arr.challenger:
		$VBox/Croupier.add_child(challenger.obj.croupier.scene.myself)

