extends MarginContainer


func full_fill(parent_, type_):
	for cellulas in parent_.arr.cellula:
		for cellula in cellulas:
			var type = type_
			
			if type_ != "Fog":
				type = cellula.word.type
				
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
		"Fog":
			tile = 4
		"Fungo":
			tile = 5
		"Snow":
			tile = 6
	
	return tile
