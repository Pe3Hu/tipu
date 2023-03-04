extends Node


class Dice:
	var arr = {}
	var num = {}
	var scene = {}


	func _init(input_):
		num.edge = 0
		arr.edge = [1,2,2,2,2,3]


	func roll() -> void:
		Global.rng.randomize()
		num.edge = Global.rng.randi_range(0, arr.edge.size()-1)
		scene.self.set_value()


class Token:
	var word = {}


	func _init(input_):
		word.type = input_.type
		word.effect = input_.effect


class Fungo:
	var num = {}
	var arr = {}
	var scene = {}


	func _init(input_):
		init_num(input_)
		init_arr()


	func init_num(input_):
		num.dice = input_.dices
		num.hp = {}
		num.hp.max = 10
		num.hp.current = num.hp.max
		num.reload = {}
		num.reload.max = input_.reload
		num.reload.current = num.reload.max


	func init_arr():
		arr.dice = []
		
		for _i in num.dice:
			var input_ = {}
			var dice = Classes_2.Dice.new(input_)
			arr.dice.append(dice)


	func roll_dices():
		for dice in arr.dice:
			dice.roll()


	func start_reload():
		scene.self.get_node("ReloadTimer").start()
