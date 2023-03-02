extends VBoxContainer


func fill_fungos(ent_) -> void:
	for fungo in ent_.arr.fungo:
		var fungo_scene = Global.scene.fungo.instance()
		fungo_scene.fill_dices(fungo)
		$HBox/Fungos.add_child(fungo_scene)
