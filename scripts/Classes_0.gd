extends Node


class Rituel:
	var num = {}
	var word = {}
	var arr = {}
	var scene = {}
	var obj = {}


	func _init(input_):
		word.name = input_.name
		word.type = input_.type
		num.charge = {}
		num.charge.max = input_.charge
		num.charge.current = 0
		arr.token = input_.tokens
		obj.ent = input_.ent
		arr.investor = []
		init_scene()


	func init_scene():
		scene.self = Global.scene.rituel.instance()
		scene.self.set_obj(self)
		var rituals = obj.ent.scene.self.get_child(1).get_node("Rituals")
		rituals.add_child(scene.self)


class Ent:
	var num = {}
	var word = {}
	var arr = {}
	var dict = {}
	var obj = {}
	var scene = {}


	func _init(input_):
		word.side = input_.side
		init_num()
		init_inclinations()
		init_bosquet()
		init_fungos()


	func init_num():
		num.fungo = {}
		num.fungo.dice = [5,4,3,2]
		num.fungo.count = [1,2,3,4]
		num.rituel = {}
		#num.rituel.current = 0
		num.rituel.max = 3


	func init_inclinations():
		dict.inclination = {}
		dict.inclination["search"] = 1
		dict.inclination["inspection"] = 1
		dict.inclination["elimination"] = 2


	func init_bosquet():
		var input = {}
		input.ent = self
		obj.bosquet = Classes_1.Bosquet.new(input)


	func init_fungos():
		arr.fungo = []
		
		for _i in num.fungo.dice.size():
			for _j in num.fungo.count[_i]:
				var input_ = {}
				input_.dices = num.fungo.dice[_i]
				Global.rng.randomize()
				input_.reload = Global.rng.randf_range(1.5, 3)
				input_.ent = self
				var fungo = Classes_2.Fungo.new(input_)
				arr.fungo.append(fungo)


	func init_facts():
		dict.fact = {}
		#dict.fact.grid = {}
		dict.fact.detail = {}
		
		for detail in Global.arr.detail:
			dict.fact.detail[detail] = []
		
		for cellulas in obj.enemy_bosquet.arr.cellula:
			for cellula in cellulas:
				var input = {}
				input.grid = cellula.vec.grid
				input.detail = -1
				var fact = Classes_0.Fact.new(input)
				dict.fact.detail[input.detail].append(fact)
		
		init_rituels()
		add_rituel()


	func init_rituels():
		var file_path = "res://assets/datas/"
		var file_name = "rituel"
		dict.rituel = Global.load_json(file_path,file_name)
		file_name = "token"
		dict.token = Global.load_json(file_path,file_name)
		arr.rituel = []
		update_rituels()


	func update_rituels():
		while arr.rituel.size() < num.rituel.max:
			add_rituel()


	func add_rituel():
		var options = []
		
		for name_ in dict.rituel.keys():
			var detail = int(dict.rituel[name_].detail)
			
			if dict.fact.detail[detail].size() > 0:
				var count = dict.rituel[name_].frequency*dict.inclination[dict.rituel[name_].type]
				
				for _i in count:
					options.append(name_)
		
		var rituel_name = Global.get_random_element(options)
		var input = {}
		input.name = rituel_name
		input.type = dict.rituel[rituel_name].type
		input.charge = 0
		input.tokens = []
		input.ent = self
		
		Global.rng.randomize()
		var token_size = Global.rng.randi_range(1, 3)
		
		options = []
		
		for name_ in dict.token.keys():
			if dict.token[name_][dict.rituel[rituel_name].type] == 1:
				options.append(name_)
		
		var token_name = Global.get_random_element(options)
		
		for _i in token_size:
			var input_ = {}
			input.name = token_name
			input.charge += dict.token[token_name].price
			var token = Classes_2.Token.new(input)
			input.tokens.append(token)
		
		input.charge *= dict.rituel[rituel_name].price
		var rituel = Classes_0.Rituel.new(input)
		arr.rituel.append(rituel)


	func start_reload():
		scene.self.get_node("ReloadTimer").start()


class Fact:
	var num = {}
	var vec = {}
	var obj = {}


	func _init(input_):
		vec.grid = input_.grid
		num.detail = input_.detail
		obj.owner = null


class Foresta:
	var num = {}
	var dict = {}
	var scene = {}


	func _init():
		init_num()
		init_scene()
		init_ents()
		start()


	func init_num():
		pass


	func init_scene():
		scene.self = Global.scene.foresta.instance()
		Global.node.Game.add_child(scene.self)


	func init_ents():
		dict.ent = {}
		
		for side in Global.SIDE:
			var input = {}
			input.side = side
			dict.ent[input.side] = Classes_0.Ent.new(input)
			dict.ent[input.side].scene.self = scene.self.get_node(input.side)
		
		update_bosquets()


	func update_bosquets():
		for _i in Global.SIDE.size():
			var side = Global.SIDE[_i]
			var next_side = Global.SIDE[(_i+1)%Global.SIDE.size()]
			dict.ent[side].obj.enemy_bosquet = dict.ent[next_side].obj.bosquet
			
		
		fill_bosquets()
		init_facts()
		init_fungos()


	func init_facts():
		for side in Global.SIDE:
			dict.ent[side].init_facts()


	func init_fungos():
		for side in Global.SIDE:
			dict.ent[side].scene.self.fill_fungos(dict.ent[side])


	func fill_bosquets():
		for side in Global.SIDE:
			for subside in Global.SIDE:
				var path = side+"/Bosquets/"+subside+"Bosquet"
				var child_bosquet = scene.self.get_node(path)
				var parent_bosquet = dict.ent[side].obj.bosquet
				
				if side == subside:
					child_bosquet.full_fill(parent_bosquet, "Empty")
				else:
					child_bosquet.full_fill(parent_bosquet, "Fog")
				
				var min_size = Vector2(parent_bosquet.num.cols, parent_bosquet.num.rows)
				min_size *= Global.vec.size.cellula * Global.vec.scale.bosquet
				child_bosquet["rect_min_size"] = min_size
				child_bosquet.get_node("Bosquet")["scale"] = Global.vec.scale.bosquet


	func start():
		for side in Global.SIDE:
			dict.ent[side].start_reload()


class Sorter:
	static func sort_ascending(a, b):
		if a.value < b.value:
			return true
		return false

	static func sort_descending(a, b):
		if a.value > b.value:
			return true
		return false
