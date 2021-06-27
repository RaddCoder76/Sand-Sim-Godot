extends Node2D

#brushes size
export var brushSize = 10

#tile ids
const BedrockID := 0
const SandID := 1
const WaterID := 2
const LavaID := 3


#current id in hand
var currentInHand = 0

#your TileSet
onready var tileSet = $World

#ready function
func _ready():
	#loops through tileset
	loopTileSet()

#looptileset funciton
func loopTileSet():
	#gets all the cell ids that are not -1 in the tileset
	var cells = tileSet.get_used_cells_by_id(1) + tileSet.get_used_cells_by_id(2) + tileSet.get_used_cells_by_id(3)
	#var cells = tileSet.get_used_cells()
	
	#loops through cells that are not empty
	for cell in cells:                         
		#gets the cells index
		var cellIndex = tileSet.get_cell(cell.x, cell.y)
		

		
		# checks if current cell is sand cell
		match cellIndex:
			SandID:
				#checks directly below the cell
				var down = checkIfCellIsEmpty(cell.x, cell.y + 1)
				#checks to the left of the cell
				var left = checkIfCellIsEmpty(cell.x - 1 , cell.y + 1)
				#checks to the right of the cell
				var right = checkIfCellIsEmpty(cell.x + 1, cell.y + 1)
				#check to the bottom left of the cell
				var downLeft = checkIfCellIsEmpty(cell.x - 1 , cell.y + 1)
				#checks to the bottom right of the cell
				var downRight = checkIfCellIsEmpty(cell.x + 1, cell.y + 1)
				
				#if both the right side and left side of the cell is empty turns one to false
				if right && left:
					if randi() % 2:
						left = false
						right = true
				
				#checks if the cell below has the water id, if it does, swap positions
				if getCellType(cell.x, cell.y + 1) == WaterID:
					tileSet.set_cell(cell.x, cell.y, WaterID)
					tileSet.set_cell(cell.x, cell.y + 1, SandID)
				
				if getCellType(cell.x, cell.y + 1) == LavaID:
					tileSet.set_cell(cell.x, cell.y, LavaID)
					tileSet.set_cell(cell.x, cell.y + 1, SandID)
				
				#checks if cell below is empty, if it does, go down
				elif down:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x, cell.y + 1, SandID)
				#checks if cell to the bottomleft is empty, if it does, go left then down
				elif left && downLeft:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x -1, cell.y + 1, SandID)
				#checks if cell to the bottomright is empty, if it does, go right then down
				elif right && downRight:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x +1, cell.y + 1, SandID)
			
			WaterID:
			#checks if the current cell is a water cell:
				#checks directly below the cell
				var down = checkIfCellIsEmpty(cell.x, cell.y + 1)
				#checks to the left of the cell
				var left = checkIfCellIsEmpty(cell.x - 1 , cell.y)
				#checks to the right of the cell
				var right = checkIfCellIsEmpty(cell.x + 1, cell.y)
				
				#if both the right side and left side of the cell is empty turns one to false
				if right && left:
					if randi() % 2:
						left = false
						right = true
				
				#checks if cell below is empty, if it does, go down
				if down:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x, cell.y + 1, WaterID)
				#checks if the cell to the left is empty, if it does, go left
				elif left:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x - 1, cell.y, WaterID)
				#checks if the cell to the right is empty, if it does, go right
				elif right:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x + 1, cell.y, WaterID)
			LavaID:
				
				#checks directly below the cell
				var down = checkIfCellIsEmpty(cell.x, cell.y + 1)
				#checks to the left of the cell
				var left = checkIfCellIsEmpty(cell.x - 1 , cell.y)
				#checks to the right of the cell
				var right = checkIfCellIsEmpty(cell.x + 1, cell.y)
				
				#if both the right side and left side of the cell is empty turns one to false
				if right && left:
					if randi() % 2:
						left = false
						right = true
				
				if getCellType(cell.x, cell.y + 1) == WaterID:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x, cell.y + 1, BedrockID)
				
				if getCellType(cell.x-1, cell.y) == WaterID:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x - 1, cell.y, BedrockID)
				
				if getCellType(cell.x+1, cell.y) == WaterID:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x + 1, cell.y, BedrockID)
					
				if getCellType(cell.x, cell.y - 1) == WaterID:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x, cell.y - 1, BedrockID)
				
				#checks if cell below is empty, if it does, go down
				if down:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x, cell.y + 1, LavaID)
				#checks if the cell to the left is empty, if it does, go left
				elif left:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x - 1, cell.y, LavaID)
				#checks if the cell to the right is empty, if it does, go right
				elif right:
					tileSet.set_cell(cell.x, cell.y, -1)
					tileSet.set_cell(cell.x + 1, cell.y, LavaID)

#function gets call when the timer it is linked to gos down to 0, you can control the speed of the physics by extending the wait time
func _physics_process(delta):
	
	loopTileSet()
	pass # Replace with function body.

# checks what type of cell is in position
func getCellType(x,y):
	return tileSet.get_cell(x,y)
	pass

#checks if the cell is empty or not and returns true or false
func checkIfCellIsEmpty(x,y):
	if tileSet.get_cell(x,y) == -1:
		# cell is empty
		return true
	else:
		return false
	pass

#all the input
func _input(event):
	#quits game
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	#restart game
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()
	
	#change current hand to 0
	if Input.is_action_just_pressed("1"):
		currentInHand = 0
	#change current hand to 1
	elif Input.is_action_just_pressed("2"):
		currentInHand = 1
	#change current hand to 2
	elif Input.is_action_just_pressed("3"):
		currentInHand = 2
	elif Input.is_action_just_pressed("4"):
		currentInHand = 3
	
	
	if Input.is_action_pressed("leftclick"):
		for x in brushSize:
			for y in brushSize:
				#topLeft
				tileSet.set_cell(get_global_mouse_position().x - x, get_global_mouse_position().y - y, currentInHand)
				#topRight
				tileSet.set_cell(get_global_mouse_position().x + x, get_global_mouse_position().y - y, currentInHand)
				#bottomLeft
				tileSet.set_cell(get_global_mouse_position().x - x, get_global_mouse_position().y + y, currentInHand)
				#bottomRight
				tileSet.set_cell(get_global_mouse_position().x + x, get_global_mouse_position().y + y, currentInHand)
	
	if Input.is_action_pressed("rightClick"):
		for x in brushSize:
			for y in brushSize:
				#topLeft
				tileSet.set_cell(get_global_mouse_position().x - x, get_global_mouse_position().y - y, -1)
				#topRight
				tileSet.set_cell(get_global_mouse_position().x + x, get_global_mouse_position().y - y, -1)
				#bottomLeft
				tileSet.set_cell(get_global_mouse_position().x - x, get_global_mouse_position().y + y, -1)
				#bottomRight
				tileSet.set_cell(get_global_mouse_position().x + x, get_global_mouse_position().y + y, -1)
	
