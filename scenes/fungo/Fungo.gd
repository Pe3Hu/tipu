extends MarginContainer


func fill_dices(fungo_) -> void:
	for dice in fungo_.arr.dice:
		var dice_scene = Global.scene.dice.instance()
		dice_scene.set_value(dice)
		$HBox/Dices.add_child(dice_scene)
