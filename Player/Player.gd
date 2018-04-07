extends Node2D


const UP = Vector2(0,-1)
const MAX_VEL = 200
const GRAVITY = 15
const ACCEL = 15
const JUMP_FORCE = -425

# references
var mousePos
var reticle
var anim

var facingRight = true
var currentAnim = "idle"
var vel = Vector2()
var friction = false

var snapshots = []

func _ready():
	
	# get animation reference
	anim = $AnimationPlayer
	
	# update camera reticle size
	reticle = $Reticle/Reticle
	reticle.updateReticleSize()
	
	# connect animation done signal
	anim.connect("animation_finished", self, "updateAnimDone")
	anim.play(currentAnim)
	
	set_process_input(true)
	
func _physics_process(delta):
	
	friction = false;
	if !is_on_floor():
		vel.y += GRAVITY
	else:
		vel.y = GRAVITY
	
	handleInput()
	
	move_and_slide(vel, UP)
	
	updateAnim()
	


func handleInput():
	
	# move left
	if Input.is_action_pressed("ui_left"):
		facingRight = false
		vel.x = max(vel.x - ACCEL,-MAX_VEL)
		currentAnim = "run"
	
	elif Input.is_action_pressed("ui_right"):
		facingRight = true
		vel.x = min(vel.x + ACCEL, MAX_VEL)
		currentAnim = "run"
	# else drag player to a half
	else:
		vel.x = lerp(vel.x, 0, 0.2)
		friction = true
		currentAnim = "idle"
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
				vel.y = JUMP_FORCE
				currentAnim = "jumpstart"
				anim.play(currentAnim)
		if friction:
			vel.x = lerp(vel.x, 0, 0.2)
	#else player is in the air
	else:
		# if moving upwards
		if vel.y < 0:
			if currentAnim != "jumpstart":
				currentAnim = "jump"
		# else moving downards
		else:
			currentAnim = "fall"
		
		if friction:
			vel.x = lerp(vel.x, 0, 0.05)

func updateAnim():
	
	if facingRight:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	if anim.current_animation != currentAnim:
		anim.play(currentAnim )

func updateAnimDone(obj):
	if currentAnim == "jumpstart":
		currentAnim = "jump"

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
	
	# update reticle paste map
	reticle.updatePasteMap(snapshot)

func placeSnapshot(snapshot):
	if reticle.placeSnapshot(snapshot):
		print("Snapshot placed.")