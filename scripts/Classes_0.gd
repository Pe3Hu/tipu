extends Node


class Spora:
	var num = {}


	func _init(input_):
		init_arr()


	func init_arr():
		pass


class Fungo:
	var num = {}


	func _init(input_):
		init_arr()


	func init_arr():
		pass


class Albero:
	var num = {}


	func _init(input_):
		init_arr()


	func init_arr():
		pass


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
	var scene = {}


	func _init(input_):
		word.side = input_.side
		init_num()
		init_arr()
		init_albero()
		init_fungos()


	func init_num():
		var n = 12
		num.rows = n
		num.cols = n
		num.blende = 3
		num.district = 3


	func init_arr():
		init_cellulas()


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
		var sizes = [5,4,3,2]
		var counts = [1,2,3,4]
		
		for _i in sizes.size():
			var fungo_size = sizes[_i]
			var fungo_count = counts[_i]
			
			for _j in fungo_count:
				var datas = get_syndicates()
				var syndicate = datas.front().syndicate
				
				if syndicate.size() >= fungo_size:
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
					
					while sporas.size() < fungo_size:
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
					
					#print("S ",syndicate.size()," F ",fungo_size, " R ", sporas.size())
					
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


	func get_syndicates():
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


	func check_border(grid_):
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
		scene = Global.scene.foresta.instance()
		Global.node.Game.add_child(scene)


	func init_bosquets():
		dict.bosquet = {}
		
		for side in Global.SIDE:
			var input = {}
			input.side = side
			dict.bosquet[input.side] = Classes_0.Bosquet.new(input)
		
		fill_bosquets()


	func fill_bosquets():
		for side in Global.SIDE:
			for subside in Global.SIDE:
				var path = side+"/"+subside+"Bosquet"
				var child_bosquet = scene.get_node(path)
				var parent_bosquet = dict.bosquet[side]
				
				if side == subside:
					child_bosquet.full_fill(parent_bosquet, "Empty")
				else:
					child_bosquet.full_fill(parent_bosquet, "Fog")
				
				var min_size = Vector2(parent_bosquet.num.cols,parent_bosquet.num.rows)
				min_size *= Global.vec.size.cellula * Global.vec.scale.bosquet
				child_bosquet["rect_min_size"] = min_size
				child_bosquet.get_node("Bosquet")["scale"] = Global.vec.scale.bosquet


class Sorter:
	static func sort_ascending(a, b):
		if a.value < b.value:
			return true
		return false

	static func sort_descending(a, b):
		if a.value > b.value:
			return true
		return false
