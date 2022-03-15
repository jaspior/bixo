extends Node2D

var map_a = preload("res://Maps/map_a.tscn")
var map_b = preload("res://Maps/map_b.tscn")
var map_c = preload("res://Maps/map_c.tscn")
var map_d = preload("res://Maps/map_g.tscn")
var map_e = preload("res://Maps/map_e.tscn")
var map_f = preload("res://Maps/map_f.tscn")
var map_g = preload("res://Maps/map_g.tscn")



func _ready():
	randomize()
	map_generator()
		
func map_generator():
	var index 
	var mapgen = 0
	var pos_x = 0
	var pos_y = 0 
	var map
	
	for i in range(10+1):
		print(mapgen)
		if mapgen == 0 or mapgen == 3 or mapgen == 5:
			index = randi() % 3
			pos_x += 1024
			if index == 0:
				map = map_a.instance()
				map.global_position = global_position + Vector2(pos_x ,pos_y)
				mapgen = 0
				add_child(map)
			
			elif index == 1: 
				map = map_b.instance()
				map.global_position = global_position + Vector2(pos_x ,pos_y)
				mapgen = 1
				add_child(map)
				
			elif index == 2:
				map = map_c.instance()
				map.global_position = global_position + Vector2(pos_x ,pos_y)
				mapgen = 2
				add_child(map)
		
		elif mapgen == 1 or mapgen == 4: 
			pos_y -= 600
			index = randi() % 2
			if index == 0: 
				map = map_d.instance()
				map.global_position = global_position + Vector2(pos_x, pos_y)
				mapgen = 3
			elif index == 1: 
				map = map_e.instance()
				map.global_position = global_position + Vector2(pos_x, pos_y)
				mapgen = 4
				add_child(map)
				
		elif mapgen == 2 or mapgen == 6: 
			pos_y += 600
			index = randi() % 2
			if index == 0: 
				map = map_f.instance()
				map.global_position = global_position + Vector2(pos_x, pos_y)
				mapgen = 5
				add_child(map)
				
			elif index == 1: 
				map = map_g.instance()
				map.global_position = global_position + Vector2(pos_x, pos_y)
				mapgen = 6
				add_child(map)

		
	
	
	
	
	
