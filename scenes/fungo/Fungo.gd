extends MarginContainer


var obj = {}


func fill_dices(fungo_) -> void:
	obj.self = fungo_
	
	for dice in fungo_.arr.dice:
		var dice_scene = Global.scene.dice.instance()
		dice.scene.self = dice_scene
		dice_scene.obj.self = dice
		$HBox/Dices.add_child(dice_scene)


func set_reload(fungo_) -> void:
	$HBox/ReloadBar.max_value = fungo_.num.reload.current*100 


func reload_tick(tick_):
	$HBox/ReloadBar.value += tick_*100
	
	if $HBox/ReloadBar.value >= $HBox/ReloadBar.max_value:
		$HBox/ReloadBar.value = 0#-= $HBox/ReloadBar.max_value
		obj.self.roll_dices()
