extends Node


var rng = RandomNumberGenerator.new()
var num = {}
var dict = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}
var vec = {}
var scene = {}


const VOWELS = ["A","E","I","O","U","Y"]
const CONSONANTS = ["B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Z"]
const ALPHABET = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
const SYLLABLE_PRECEDENCES = ["Senior","Junior"]
const SYLLABLE_SIZES = [2,3]
const LETRE_COST = {
	"consonant": {
	},
	"vowel": {
	}
}
const SIDE = ["First","Second"]


var mouse_pressed = false


func init_num():
	init_primary_key()
	
	num.map = {}


func init_primary_key():
	num.primary_key = {}
	num.primary_key.vicinity = 0


func init_dict():
	init_window_size()
	
	dict.neighbor = {}
	dict.neighbor.linear = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	
	dict.tag = {}
	dict.tag.clone = {
		"basic": 1
	}
	
	for key in LETRE_COST:
		var step_size = 0 
		var begin_size = 0
		var grades = 0
		var index = 0
		var type = key.to_upper()+"S"
		
		match key:
			"vowel":
				step_size = 1
				begin_size = 3
				grades = 3
			"consonant":
				step_size = 2
				begin_size = 8
				grades = 4
		
		for grade in grades:
			LETRE_COST[key][grade+1] = []
		
			for _i in begin_size:
				var letter = self[type][index]
				LETRE_COST[key][grade+1].append(letter)
				index += 1
			
			begin_size -= step_size


func init_window_size():
	dict.window_size = {}
	dict.window_size.width = ProjectSettings.get_setting("display/window/size/width")
	dict.window_size.height = ProjectSettings.get_setting("display/window/size/height")
	dict.window_size.center = Vector2(dict.window_size.width/2, dict.window_size.height/2)


func init_arr():
	arr.sequence = {} 
	arr.sequence["A000040"] = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
	arr.sequence["A000045"] = [89, 55, 34, 21, 13, 8, 5, 3, 2, 1, 1]
	arr.sequence["A000124"] = [7, 11, 16] #, 22, 29, 37, 46, 56, 67, 79, 92, 106, 121, 137, 154, 172, 191, 211]
	arr.sequence["A001358"] = [4, 6, 9, 10, 14, 15, 21, 22, 25, 26]
	arr.sequence["B000000"] = [2, 3, 5, 8, 10, 13, 17, 20, 24, 29, 33, 38]
	arr.detail = [-1,0,1,2,3]
	arr.rituel = ["search","inspection","elimination"]


func init_node():
	node.Game = get_node("/root/Game") 


func init_flag():
	flag.click = false
	flag.stop = false


func init_vec():
	vec.size = {}
	vec.size.cellula = Vector2(64,64)
	
	vec.scale = {}
	vec.scale.bosquet = Vector2(0.25,0.25)


func init_scene():
	scene.bosquet = load("res://scenes/bosquet/Bosquet.tscn")
	scene.foresta = load("res://scenes/foresta/Foresta.tscn")
	scene.token = load("res://scenes/token/Token.tscn")
	scene.rituel = load("res://scenes/rituel/Rituel.tscn")
	scene.fungo = load("res://scenes/fungo/Fungo.tscn")
	scene.dice = load("res://scenes/dice/Dice.tscn")


func _ready():
	init_dict()
	init_num()
	init_arr()
	init_node()
	init_flag()
	init_vec()
	init_scene()


func get_random_element(arr_: Array):
	if arr_.size() == 0:
		print("!bug! empty array in get_random_element func")
		return null
	
	rng.randomize()
	var index_r = rng.randi_range(0, arr_.size()-1)
	return arr_[index_r]


func save_json(data_,file_path_,file_name_) -> void:
	var file = File.new()
	file.open(file_path_+file_name_+".json", File.WRITE)
	file.store_line(to_json(data_))
	file.close()


func load_json(file_path_,file_name_) -> Dictionary:
	var file = File.new()
	
	if not file.file_exists(file_path_+file_name_+".json"):
			 #save_json()
			 return {}
	
	file.open(file_path_+file_name_+".json", File.READ)
	var data = parse_json(file.get_as_text())
	return data

