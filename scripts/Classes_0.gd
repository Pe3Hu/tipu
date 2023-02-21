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
		num.blendes = 3


	func init_arr():
		init_cellulas()


	func init_cellulas():
		arr.cellula = []
		
		for _i in num.rows:
			arr.cellula.append([])
			
			for _j in num.cols:
				var input = {}
				input.grid = Vector2(_j,_i)
				var cellula = Classes_0.Cellula.new(input)
				arr.cellula[_i].append(cellula)
		
		set_cellula_neighbors()


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


	func init_albero():
		var options = []
		
		for cellulas in arr.cellula:
			for cellula in cellulas:
				if cellula.num.neighbor == 8:
					options.append(cellula)
				else:
					cellula.word.type = "Snow"
		
		for _i in num.blendes:
			var cellula = Global.get_random_element(options)
			
			for type in cellula.dict.neighbor.keys():
				for vector in cellula.dict.neighbor[type]:
					var neighbor = cellula.dict.neighbor[type][vector]
					options.erase(neighbor)
					neighbor.word.type = "Snow"
			
			cellula.word.type = "Albero"


	func init_fungos():
		var options = []
		
		for cellulas in arr.cellula:
			for cellula in cellulas:
				if cellula.is_empty():
					options.append(cellula)
		
		print(options.size())

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

