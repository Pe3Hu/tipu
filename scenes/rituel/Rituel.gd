extends MarginContainer
class_name RituelNode

var obj = {}


func set_obj(rituel_) -> void:
	obj.self = rituel_
	$VBox/Name.text = obj.self.word.name
	set_charge()


func set_charge() -> void:
	$VBox/ChargeLabel.text = str(obj.self.num.charge.current)+"/"+str(obj.self.num.charge.max)
	$VBox/ChargeBar.value = float(obj.self.num.charge.current)/obj.self.num.charge.max
