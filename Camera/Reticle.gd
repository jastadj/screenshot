extends Node2D

# reticle properties
var width = 4
var height = 3

# references
var camera
var player
var tilemap
var pastemap

# classes
var snapshotObj

var _r

func _ready():
	
	_r = get_node("ReticleTileMap")
	
	# get player, camera, and tilemap references
	player = get_parent().get_parent()
	camera = player.get_node("Camera2D")
	tilemap = get_node("/root/World/TileMap")
	pastemap = get_node("PasteTileMap")
	
	# get class references
	snapshotObj = load("res://Camera/snapshot.gd")
	
	

func _process(delta):
	if is_visible_in_tree():
		
		# get global mouse position
		var gmouse = get_parent().get_parent().get_global_mouse_position()
		
		# snap global mouse position to tile position
		gmouse = Vector2( floor(gmouse.x/32), floor(gmouse.y/32) ) * 32
		
		# set reticle positon to converted snapped global mouse
		# position to screen position
		position = camera.WorldToScreen(gmouse)
		
		
		
func takeSnapshot():

	# if reticle is invisible, ignore command
	if is_visible_in_tree() == false:
		return null
	
	# array of tile values for snapshot
	var newsnapshot = snapshotObj.new(width,height)
	
	#debug
	#print("snapshot dims : " + str(snapshot[0].size()) + "," + str(snapshot.size()) )
	
	# get global mouse position
	var gmouse = get_parent().get_parent().get_global_mouse_position()
	var gtile = Vector2( floor(gmouse.x/32), floor(gmouse.y/32) )
	# snap global mouse position to tile position
	gmouse = gtile * 32
	
	# check that tile position is in bounds
	#if gtile.x < 0 || gtile.y < 0:
	#	return null
	
	# debug
	#print( "(" + str(gtile.x) + "," + str(gtile.y) + ") , (" + str(gtile.x + width) + "," + str(gtile.y + height) + ")" )
	#return null
	
	# capture tile array starting with snapped tile position for width and height
	for y in range(height):
		for x in range(width):
			newsnapshot.tiles[y][x] = tilemap.get_cell(gtile.x + x, gtile.y + y)
	
	
	#debug
	newsnapshot.printSnapshot()
	
	return newsnapshot

func placeSnapshot(snapshot):
	
	if snapshot == null:
		return false
	
	# get global mouse position
	var gmouse = get_parent().get_parent().get_global_mouse_position()
	var gtile = Vector2( floor(gmouse.x/32), floor(gmouse.y/32) )
	# snap global mouse position to tile position
	gmouse = gtile * 32

	# check that tile position is in bounds
	#if gtile.x < 0 || gtile.y < 0:
	#	return null

	# check that tile placement area is clear
	#var areaclear = true
	#for y in range(gtile.y, gtile.y + snapshot.height):
	#	for x in range(gtile.x, gtile.x + snapshot.width):
	#		if tilemap.get_cell(x,y) != -1:
	#			areaclear = false

	#if !areaclear:
	#	print("Snapshot paste blocked by tiles.")
	#	return false
		
	# set tile map to snapshot tiles
	for y in range(snapshot.height):
		for x in range(snapshot.width):
			var ttile = snapshot.tiles[y][x]
			var tpos = Vector2(gtile.x + x, gtile.y + y)
			if ttile >= 0 && tilemap.get_cell(tpos.x, tpos.y) == -1:
				tilemap.set_cell(tpos.x, tpos.y, snapshot.tiles[y][x])
	
	return true

func updatePasteMap(snapshot):
	
	if snapshot == null:
		return
	
	for y in range(snapshot.height):
		for x in range(snapshot.width):
			pastemap.set_cell(x,y, snapshot.tiles[y][x])
	
	pass

func updateReticleSize():
	
	var tw = width * 4
	var th = height * 4
	
	# set top left corner
	_r.set_cell(0,0,0)
	
	# add top middle
	for i in range(1,tw-1):
		_r.set_cell(i,0,1)
	
	# add top right corner
	_r.set_cell(tw-1,0,2)
	
	# add rows
	for row in range(1,th-1):
		_r.set_cell(0,row, 3)
		_r.set_cell(tw-1, row, 5)
	
	# add bottom left corner
	_r.set_cell(0, th-1, 6)
	
	# add bottom middle
	for i in range(1,tw-1):
		_r.set_cell(i,th-1,7)
		
	# add bottom right corner
	_r.set_cell(tw-1, th-1, 8)
	
