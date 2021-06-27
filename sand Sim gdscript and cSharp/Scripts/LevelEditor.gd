extends Node2D

export (int) var tileSize = 32
export (Texture) var map
var mapImage
export (Dictionary) var tileDictionary




func _ready():
	if map != null:
		_GenerateLevel()

func _GenerateLevel():
	mapImage = map.get_data() as Image
	for x in range(mapImage.get_width()):
		for y in range(mapImage.get_height()):
			_GenerateTile(x,y)
		pass
	pass

func _GenerateTile(x,y):
	mapImage.lock()
	var pixelColor = mapImage.get_pixel(x,y) as Color
	
	if pixelColor.a == 0:
		#pixel is transparent
		return
	
	for key in tileDictionary:
		if key == pixelColor:
			_SpawnTile(x,y, key)
		
		pass
	pass

func _SpawnTile(x, y, _key):
	#var tileInstance = tileDictionary[key].instance()
	#tileInstance.position = Vector2(x*tileSize,y*tileSize)
	#get_tree().current_scene.call_deferred("add_child", tileInstance)
	
	var tileSet = get_tree().root.get_child(0).get_child(0).get_child(0) as TileMap
	
	tileSet.call_deferred("set_cell", x, y, tileDictionary[_key])
	
	#tileSet.set_cell(x,y, tileDictionary[key])
	pass
