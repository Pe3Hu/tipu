extends MarginContainer


var obj = {}


func set_value() -> void:
	$Value.text = String(obj.self.arr.edge[obj.self.num.edge])
