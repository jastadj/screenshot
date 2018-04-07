extends Node2D

var mousePos
var reticle

var snapshots = []

func _ready():

	
	# update camera reticle size
	reticle = $Reticle/Reticle
	reticle.updateReticleSize()
	
	set_process_input(true)
	
func _physics_process(delta):
	
	#move_and_slide(Vector2(0,50), Vector2(0,-1) )
	pass

func _process(delta):
	
	if Input.is_action_pressed("ui_left"):
		move_and_slide(Vector2(-50,0), Vector2(0,-1) )
	elif Input.is_action_pressed("ui_right"):
		move_and_slide(Vector2(50,0), Vector2(0,-1) )
	
	if Input.is_action_pressed("ui_down"):
		move_and_slide(Vector2(0,50), Vector2(0,-1) )
	elif Input.is_action_pressed("ui_up"):
		move_and_slide(Vector2(0,-50), Vector2(0,-1) )
	
	pass
	

func _input(event):
	
	if event.is_action("ui_takesnapshot") && event.is_pressed():
		var newsnapshot = reticle.takeSnapshot()
		
		if newsnapshot == null:
			print("Error taking snapshot, it is null!")
		
		addSnapshot(newsnapshot)
	
	elif event.is_action("ui_placesnapshot") && event.is_pressed():
		if snapshots.empty():
			print("snapshots are empty")
		else:
			placeSnapshot( snapshots[ snapshots.size()-1] )
			
func addSnapshot(snapshot):
	snapshots.append(snapshot)
	print("Snapshot added.")

func placeSnapshot(snapshot):
	if reticle.placeSnapshot(snapshot):
		print("Snapshot placed.")