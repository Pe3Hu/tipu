extends VBoxContainer


var obj = {}


func fill_fungos(ent_) -> void:
	obj.self = ent_
	
	for fungo in ent_.arr.fungo:
		var fungo_scene = Global.scene.fungo.instance()
		fungo_scene.fill_dices(fungo)
		fungo_scene.set_reload(fungo)
		fungo.scene.self = fungo_scene
		$HBox/Fungos.add_child(fungo_scene)


func _on_Timer_timeout():
	for fungo in obj.self.arr.fungo:
		fungo.scene.self.reload_tick($ReloadTimer.wait_time)
