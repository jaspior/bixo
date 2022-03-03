extends Node2D


var map_lobby = [preload("res://Maps/map_a.tscn"),preload("res://Maps/map_b.tscn"),preload("res://Maps/map_c.tscn")]
var map_a = [preload("res://Maps/map_a.tscn"),preload("res://Maps/map_b.tscn"),preload("res://Maps/map_c.tscn")]
var map_b = [preload("res://Maps/map_d.tscn"),preload("res://Maps/map_e.tscn")]
var map_c = [preload("res://Maps/map_f.tscn"),preload("res://Maps/map_g.tscn")]
var map_d = [preload("res://Maps/map_a.tscn"),preload("res://Maps/map_b.tscn"),preload("res://Maps/map_c.tscn")]
var map_e = [preload("res://Maps/map_d.tscn"),preload("res://Maps/map_e.tscn")]
var map_f = [preload("res://Maps/map_a.tscn"),preload("res://Maps/map_b.tscn"),preload("res://Maps/map_c.tscn")]
var map_g = [preload("res://Maps/map_f.tscn"),preload("res://Maps/map_g.tscn")]

var mapgen = 0
var nextgen = 0
var pos_x = 0
var pos_y = 0 


func _ready():
	randomize()
	for i in range(10+1):
		if mapgen == 0: 
			pos_x += 1024
		elif mapgen == 1:
			pos_y -= 600
		elif mapgen == 2: 
			pos_y += 600
			
		mapgen = map_generator(mapgen,pos_x,pos_y)
		
func map_generator(n,pos_x,pos_y):
	if n == 0:
		var index = randi() % 3
		var map = map_a[index].instance()
		map.global_position = global_position + Vector2(pos_x ,pos_y)
		add_child(map)
		
		return index
		
	elif n == 1:
		var index = randi() % 2
		var map = map_b[index].instance()
		map.global_position = global_position + Vector2(pos_x,pos_y)
		add_child(map)

		return index

	elif n == 2:
		var index = randi() % 2
		var map = map_c[index].instance()
		map.global_position = global_position + Vector2(pos_x,pos_y)
		add_child(map)
	
		return index
