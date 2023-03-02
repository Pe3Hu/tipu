extends MarginContainer


func set_value(dice) -> void:
	$Value.text = String(dice.arr.edge[dice.num.edge])
