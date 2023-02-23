extends MarginContainer


func full_fill(parent_, type_):
	for cellulas in parent_.arr.cellula:
		for cellula in cellulas:
			var type
			
			if type_ != "Fog":
				type = cellula.word.type
			else:
				type = type_+"_"+str(cellula.num.fog)
			
			fill_cell(cellula.vec.grid,type)


func fill_cell(vec_,type_):
	var tile = set_tile_by_type(type_)
	$Bosquet.set_cellv(vec_,tile)


func set_tile_by_type(type_):
	var tile = -1
	
	match type_:
		"Albero":
			tile = 0
		"Branch":
			tile = 1
		"Corpse":
			tile = 2
		"Empty":
			tile = 3
		"Fog_1":
			tile = 4
		"Fog_2":
			tile = 5
		"Fog_3":
			tile = 6
		"Fog_4":
			tile = 7
		"Fungo":
			tile = 8
		"Snow":
			tile = 9
	
	return tile
