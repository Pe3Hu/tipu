extends Node


class Spora:
	var num = {}


	func _init(input_):
		init_arr()


	func init_arr():
		pass


class Dice:
	var arr = {}
	var num = {}


	func _init(input_):
		num.edge = 0
		arr.edge = [1,2,2,2,2,3]
		roll()


	func roll() -> void:
		Global.rng.randomize()
		num.edge = Global.rng.randi_range(0, arr.edge.size()-1)


class Token:
	var word = {}


	func _init(input_):
		word.type = input_.type
		word.effect = input_.effect


class Rituel:
	var num = {}
	var word = {}
	var arr = {}
	var scene = {}
	var obj = {}


	func _init(input_):
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
		var rituals = obj.ent.scene.self.get_child(1).get_node("Rituals")
		rituals.add_child(scene.self)


class Fungo:
	var num = {}
	var arr = {}


	func _init(input_):
		init_num(input_)
		init_arr()


	func init_num(input_):
		num.dice = input_.dices
		num.hp = {}
		num.hp.max = 10
		num.hp.current = num.hp.max


	func init_arr():
		arr.dice = []
		
		for _i in num.dice:
			var input_ = {}
			var dice = Classes_0.Dice.new(input_)
			arr.dice.append(dice)


class Albero:
	var num = {}


	func _init(input_):
		init_arr()


	func init_arr():
		pass


class Ent:
	var num = {}
	var arr = {}
	var dict = {}
	var obj = {}
	var scene = {}


	func _init(input_):
		obj.bosquet = input_.bosquet
		obj.bosquet.obj.ent = self
		init_num()
		init_inclinations()
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


	func init_fungos():
		arr.fungo = []
		
		for _i in num.fungo.dice.size():
			for _j in num.fungo.count[_i]:
				var input_ = {}
				input_.dices = num.fungo.dice[_i]
				var fungo = Classes_0.Fungo.new(input_)
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


	func init_rituels():
		arr.rituel = []
		update_rituels()


	func update_rituels():
		while arr.rituel.size() < num.rituel.max:
			add_rituel()


	func add_rituel():
		var options = []
		
		for rituel in dict.inclination.keys():
			var details = Global.dict.rituel.detail[rituel]
			var data = {}
			data.count = 0
			data.rituel = rituel
			
			for detail in details:
				data.count += dict.fact.detail[detail].size()
			
			if data.count > 0:
				for _i in dict.inclination[rituel]:
					options.append(rituel)
		
		
		
		var option = Global.get_random_element(options)
		var datas = [{"type": option}]
		
		for key in Global.dict.frequency[option].keys():
			var datas_ = []
			
			for subkey in Global.dict.frequency[option][key].keys():
				#print(key, " ", subkey, datas_.back())
				
				for data in datas:
					for _i in Global.dict.frequency[option][key][subkey]:
						var data_ = {}
						
						for key_ in data.keys():
							data_[key_] = data[key_]
						
						data_[key] = subkey
						datas_.append(data_)
				
			datas.append_array(datas_)
		
		var keys = Global.dict.frequency.inspection.keys().size()+1

		for _i in range(datas.size()-1,-1,-1):
			var data = datas[_i]
			
			if data.keys().size() != keys:
				datas.erase(data)
		
		var data = Global.get_random_element(datas)
		var input = {}
		input.type = "#"#data.type
		input.effect = ""
		var token = Classes_0.Token.new(input)
		print(data)
		input = {}
		input.type = ""#option.rituel
		input.charge = 100#option.price
		input.tokens = []#option.tokens
		input.ent = self
		var rituel = Classes_0.Rituel.new(input)
		arr.rituel.append(rituel)


class Fact:
	var num = {}
	var vec = {}
	var obj = {}


	func _init(input_):
		vec.grid = input_.grid
		num.detail = input_.detail
		obj.owner = null


class Cellula:
	var num = {}
	var word = {}
	var vec = {}
	var dict = {}


	func _init(input_):
		num.neighbor = 0
		num.wave = input_.wave
		word.type = "Empty"
		vec.grid = input_.grid


	func is_empty():
		return word.type == "Empty"


class Bosquet:
	var num = {}
	var word = {}
	var arr = {}
	var obj = {}
	var scene = {}


	func _init(input_):
		word.side = input_.side
		init_num()
		init_arr()


	func init_num():
		var n = 12
		num.rows = n
		num.cols = n
		num.blende = 3
		num.district = 3


	func init_arr():
		init_cellulas()
		init_ent()
		init_albero()
		init_fungos()


	func init_cellulas():
		var ceil_shift = -0.5
		arr.cellula = []
		
		for _i in num.rows:
			arr.cellula.append([])
			
			for _j in num.cols:
				var input = {}
				input.grid = Vector2(_j,_i)
				input.wave = max(abs(_i-float(num.rows-1)/2),abs(_j-float(num.cols-1)/2))+ceil_shift
				var cellula = Classes_0.Cellula.new(input)
				arr.cellula[_i].append(cellula)
		
		set_cellula_neighbors()
		set_districts()


	func set_cellula_neighbors():
		for cellulas in arr.cellula:
			for cellula in cellulas:
				cellula.dict.neighbor = {}
				
				for type in Global.dict.neighbor.keys():
					cellula.dict.neighbor[type] = {}
					
					for vector in Global.dict.neighbor[type]:
						var neighbor_grid = cellula.vec.grid + vector
						
						if check_border(neighbor_grid):
							var neighbor = arr.cellula[neighbor_grid.y][neighbor_grid.x]
							cellula.dict.neighbor[type][vector] = neighbor
							cellula.num.neighbor += 1


	func set_districts():
		var districts = []
		var district_size = num.rows*num.cols/num.district
		var waves = []
		
		
		for _i in max(num.rows,num.cols)/2:
			waves.append([])
		
		for cellulas in arr.cellula:
			for cellula in cellulas:
				waves[cellula.num.wave].append(cellula)
		
		for _i in num.district:
			districts.append([])
			
			while waves.size() > 0 && districts[_i].size() < district_size:
				var cellula = Global.get_random_element(waves.front())
				waves.front().erase(cellula)
				districts[_i].append(cellula)
				
				if waves.size() > 0:
					if waves.front().size() == 0:
						waves.pop_front()
		
		if waves.size() > 0:
			districts.back().append_array(waves.front())
		
		for _i in districts.size():
			for cellula in districts[_i]:
				cellula.num.fog = districts.size()-_i


	func init_ent():
		var input_ = {}
		input_.bosquet = self
		obj.ent = Classes_0.Ent.new(input_)


	func init_albero():
		var options = []
		var alberos = []
		
		for cellulas in arr.cellula:
			for cellula in cellulas:
				var n = pow(3,cellula.num.fog-1)
				
				for _i in n:
					options.append(cellula)
		
		for _i in num.blende:
			var cellula = Global.get_random_element(options)
			cellula.word.type = "Albero"
			alberos.append(cellula)
			
			while options.has(cellula):
				options.erase(cellula)
		
		for albero in alberos:
			for linear in albero.dict.neighbor["linear"]:
				var branch = albero.dict.neighbor["linear"][linear]
				
				for type in branch.dict.neighbor.keys():
					for vector in branch.dict.neighbor[type]:
						var neighbor = branch.dict.neighbor[type][vector]
						
						if neighbor.is_empty():
							neighbor.word.type = "Snow"


	func init_fungos():
		for _i in obj.ent.num.fungo.dice.size():
			var fungo_dices = obj.ent.num.fungo.dice[_i]
			var fungo_count = obj.ent.num.fungo.count[_i]
			
			for _j in fungo_count:
				var datas = get_syndicates()
				var syndicate = datas.front().syndicate
				
				if syndicate.size() >= fungo_dices:
					var min_neighbors = 8
					
					for data in syndicate:
						if data.neighbors.size() < min_neighbors:
							min_neighbors = data.neighbors.size()
					
					var options = []
					
					for data in syndicate:
						if data.neighbors.size() == min_neighbors:
							for _l in data.n:
								options.append(data)
					
					var option = Global.get_random_element(options)
					var sporas = [option]
					var neighbors = []
					
					for data in syndicate:
						if option.neighbors.has(data.cellula):
							neighbors.append(data)
					
					while sporas.size() < fungo_dices:
						options = []
						
						for data in neighbors:
							for _l in data.n:
								options.append(data)
						
						if options.size() > 0:
							option = Global.get_random_element(options)
							sporas.append(option)
							neighbors.erase(option)
							
							for data in syndicate:
								if option.neighbors.has(data.cellula) && !sporas.has(data):
									neighbors.append(data)
						else:
							"!bug! options for sporas is empty"
					
					#print("S ",syndicate.size()," F ",fungo_dices, " R ", sporas.size())
					
					for data in sporas:
						data.cellula.word.type = "Fungo"
						
					
					for data in sporas:
						for type in data.cellula.dict.neighbor.keys():
							for vector in data.cellula.dict.neighbor[type]:
								var neighbor = data.cellula.dict.neighbor[type][vector]
								
								if neighbor.is_empty():
									neighbor.word.type = "Snow"
					
				else:
					print("!bug! fungo bigger than syndicate")


	func get_syndicates() -> Array:
		var options = []
		var unions = {}
		
		for cellulas in arr.cellula:
			for cellula in cellulas:
				if cellula.is_empty():
					var option = {}
					option.cellula = cellula
					option.n = pow(3,cellula.num.fog-1)
					option.neighbors = []
					unions[cellula] = []
					option.unrelated = true
					
					for linear in cellula.dict.neighbor["linear"]:
						var neighbor = cellula.dict.neighbor["linear"][linear] 
						
						if neighbor.is_empty():
							option.neighbors.append(neighbor)
					
					unions[cellula].append_array(option.neighbors)
					options.append(option)
		
		for option in options:
			if option.unrelated:
				option.unrelated = false
				var waves = []
				waves.append_array(unions[option.cellula])
				
				while waves.size() > 0:
					var wave = waves.pop_front()
					
					for option_ in options:
						if option_.cellula == wave:
							option_.unrelated = false
							break
					
					for neighbor in unions[wave]:
						if !unions[option.cellula].has(neighbor):
							waves.append(neighbor)
							unions[option.cellula].append(neighbor)
		
		var syndicates = []
		var sub_unions = []
		
		for cellula in unions.keys():
			var flag = true
			
			for sub_union in sub_unions:
				flag = flag && !sub_union.has(cellula)
			
			if flag:
				var sub_union = unions[cellula]
				
				if sub_union.size() == 0:
					sub_union.append(cellula)
					
				sub_unions.append(sub_union)
		
		for sub_union in sub_unions:
			var syndicate = []
			
			for option in options:
				if sub_union.has(option.cellula):
					syndicate.append(option)
			
			syndicates.append(syndicate)
		
		var datas = []
		
		for syndicate in syndicates:
			var data = {}
			data.syndicate = syndicate
			data.value = syndicate.size()
			datas.append(data)
		
		datas.sort_custom(Sorter, "sort_descending")
		
		return datas


	func check_border(grid_) -> bool:
		return grid_.x >= 0 && grid_.x < num.cols && grid_.y >= 0 && grid_.y < num.rows


class Foresta:
	var num = {}
	var dict = {}
	var scene = {}


	func _init():
		init_num()
		init_scene()
		init_bosquets()


	func init_num():
		pass


	func init_scene():
		scene.self = Global.scene.foresta.instance()
		Global.node.Game.add_child(scene.self)


	func init_bosquets():
		dict.bosquet = {}
		
		for side in Global.SIDE:
			var input = {}
			input.side = side
			dict.bosquet[input.side] = Classes_0.Bosquet.new(input)
		
		for _i in Global.SIDE.size():
			var side = Global.SIDE[_i]
			var next_side = Global.SIDE[(_i+1)%Global.SIDE.size()]
			dict.bosquet[side].obj.ent.obj.enemy_bosquet = dict.bosquet[next_side]
			
		
		fill_bosquets()
		
		for side in Global.SIDE:
			dict.bosquet[side].obj.ent.init_facts()
			
		for side in Global.SIDE:
			dict.bosquet[side].obj.ent.scene.self.fill_fungos(dict.bosquet[side].obj.ent)


	func fill_bosquets():
		for side in Global.SIDE:
			for subside in Global.SIDE:
				var path = side+"/Bosquets/"+subside+"Bosquet"
				var child_bosquet = scene.self.get_node(path)
				var parent_bosquet = dict.bosquet[side]
				
				
				if side == subside:
					child_bosquet.full_fill(parent_bosquet, "Empty")
				else:
					child_bosquet.full_fill(parent_bosquet, "Fog")
				
				var min_size = Vector2(parent_bosquet.num.cols,parent_bosquet.num.rows)
				min_size *= Global.vec.size.cellula * Global.vec.scale.bosquet
				child_bosquet["rect_min_size"] = min_size
				child_bosquet.get_node("Bosquet")["scale"] = Global.vec.scale.bosquet
				parent_bosquet.obj.ent.scene.self = scene.self.get_node(side)


class Sorter:
	static func sort_ascending(a, b):
		if a.value < b.value:
			return true
		return false

	static func sort_descending(a, b):
		if a.value > b.value:
			return true
		return false
