extends Node


class Dice:
	var arr = {}
	var num = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		obj.fungo = input_.fungo
		num.edge = 0
		arr.tag = input_.tags
		arr.edge = [1,2,2,2,2,3]


	func roll() -> void:
		Global.rng.randomize()
		num.edge = Global.rng.randi_range(0, arr.edge.size()-1)
		scene.self.set_value()


class Token:
	var word = {}


	func _init(input_) -> void:
		word.name = input_.name


class Charge:
	var dict = {}
	var obj = {}


	func _init(input_) -> void:
		obj.fungo = input_.fungo
		set_tags()


	func set_tags() -> void:
		dict.tag = {}
		
		for dice in obj.fungo.arr.dice:
			for tag in dice.arr.tag:
				if !dict.tag.keys().has(tag):
					dict.tag[tag] = 0


	func set_values() -> void:
		for tag in dict.tag.keys():
			dict.tag[tag] = 0
			var scale = 1
			
			for dice in obj.fungo.arr.dice:
				dict.tag[tag] += dice.arr.edge[dice.num.edge]*scale


class Fungo:
	var num = {}
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_) -> void:
		obj.ent = input_.ent
		init_num(input_)
		init_arr()
		init_charge()


	func init_num(input_) -> void:
		num.dice = input_.dices
		num.hp = {}
		num.hp.max = 10
		num.hp.current = num.hp.max
		num.reload = {}
		num.reload.max = input_.reload
		num.reload.current = num.reload.max


	func init_arr() -> void:
		arr.dice = []
		
		for _i in num.dice:
			var input = {}
			input.fungo = self
			input.tags = []
			var options = []
			
			for tag in Global.dict.tag.clone.keys():
				for _k in Global.dict.tag.clone[tag]:
					options.append(tag)
			
			var tag = Global.get_random_element(options)
			input.tags.append(tag)
			var dice = Classes_2.Dice.new(input)
			arr.dice.append(dice)


	func init_charge() -> void:
		var input = {}
		input.fungo = self
		obj.charge = Classes_2.Charge.new(input)


	func roll_dices() -> void:
		for dice in arr.dice:
			dice.roll()
		
		choose_rituel()


	func choose_rituel() -> RituelNode:
		var datas = []
		
		for rituel in obj.ent.arr.rituel:
			var data = {}
			data.rituel = rituel
			data.value = 0
			datas.append(rituel.scene.self)
		
		var data = Global.get_random_element(datas)
		return data.rituel


	func start_reload() -> void:
		scene.self.get_node("ReloadTimer").start()
