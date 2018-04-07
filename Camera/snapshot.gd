var tiles = []
var height = 0
var width = 0

func _init(w, h):
	
	height = h
	width = w
	
	# create snapshot array based on camera reticle height and width
	tiles.resize(height)
	
	# init array with -1 (empty tiles)
	for y in range(height):
		tiles[y] = []
		tiles[y].resize(width)
		for x in range(width):
			tiles[y][x] = -1

# for debug purposes
func printSnapshot():
	
	print("\nDims:" + str(width) + "," + str(height) )
	
	for y in range(height):
		var rowstr = ""
		for x in range(width):
			if tiles[y][x] == -1:
				rowstr += str("_")
			else:
				rowstr += str(tiles[y][x])
			
			if x != width-1:
				rowstr += ","
	
		print(rowstr)