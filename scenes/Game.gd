extends Control


func _ready():
	Global.obj.foresta = Classes_0.Foresta.new()
#	datas.sort_custom(Sorter, "sort_ascending")


func _input(event):
	if event is InputEventMouseButton:
		Global.mouse_pressed = !Global.mouse_pressed
	else:
		Global.mouse_pressed = !Global.mouse_pressed
