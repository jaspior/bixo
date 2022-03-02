extends Node2D

var maps = [preload("res://Maps/Map2.tscn"),preload("res://Maps/Map3.tscn"),preload("res://Maps/Map4.tscn")]


func _ready():
	for i in len(maps):
		var index = randi() % 2
		var map = maps[index].instance()
		map.global_position = global_position + Vector2( (i+1) * 1024 , 0 )
		add_child(map)
