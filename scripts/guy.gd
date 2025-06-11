extends CharacterBody2D

@onready var coyoteTimer: Timer = $coyoteTimer
@onready var jumpBufferTimer: Timer = $jumpBufferTimer

@onready var leftRay: RayCast2D = $wallRays/leftRay
@onready var rightRay: RayCast2D = $wallRays/rightray

var coyoteTimeActivated = false

const jumpHeight: float = -425.0
const maxGravity: float = 15.0

var gravity: float = 12.0
var applyGravity = true
const maxSpeed: float = 160
const acceleration: float = 18
const friction: float = 20

@export_category("wall jump")
@export var wallSlide = 30.0
@export var wallXForce = 200.0
@export var wallYForce = -320.0
var canWallJump = 3
var wallLeniency = true


var canControl:bool = true
var deathPos = Vector2(248, 153)


func _ready() -> void:
	# sets player initial location
	
	#global_position = deathPos
	global_position = get_parent().get_node("checkpoints/checkpoint8").position


func resetLevers():
	get_parent().get_node("keyblocksInitialOn").enabled = true
	get_parent().get_node("keyblocksInitialOff").enabled = false
	if get_parent().get_node("levers").get_node("leverLeft1").down == true:
		for child in get_parent().get_node("levers").get_children():
			child.leverUp()


func resetPlayer() -> void:
	
	$AnimatedSprite2D.play("death")
	canControl = false
	applyGravity = false
	await get_tree().create_timer(0.5).timeout
	velocity = Vector2.ZERO
	applyGravity = true
	canControl = true
	global_position = deathPos
	
	resetLevers()
	
	print("respawned")



func cameraOffsetControl():
	pass
	# figure out way to make it so the camera moves to have more visibility in the direction the player is moving



func _process(delta: float) -> void:

	if Input.is_action_just_pressed("respawn"):
		resetPlayer()
	
	# checks if the obstacles tilemaplayer is interacting with group "guy"
	# if so, reset player
	var obstacleColl = get_parent().get_node("obstacles").is_in_group("guy")
	
	if obstacleColl:
		resetPlayer()
		print("died to obstacle tilemap")
	
	
	# stops entire physics process when canControl is false
	if not canControl: return
	
	
	#HORIZONTAL MOVEMENT
	# returns 0, -1, or 1 based on what key is being pressed
	var xInput: float = Input.get_action_strength("move-right") - Input.get_action_strength("move-left")
	# decides whether acceleration or friction is used for the lerp
	var velocityWeight: float = delta * (acceleration if xInput else friction)
	# makes the player move smoothly from velocity.x to xInput * maxSpeed, affected by velocityWeight
	velocity.x = lerp(velocity.x, xInput * maxSpeed, velocityWeight)
	
	# plays appropriate animations if player is on floor
	if is_on_floor():
		if (velocity.x < -1):
			$AnimatedSprite2D.play("left")
		elif (velocity.x > 1):
			$AnimatedSprite2D.play("right")
		else:
			$AnimatedSprite2D.play("idle")
	
	#JUMP
	if is_on_floor():
		coyoteTimeActivated = false
		gravity = lerp(gravity, 12.0, 12.0 * delta)
		canWallJump = 3
	else:
		# checks if coyote timer is activated already; if not, starts
		if coyoteTimer.is_stopped() and !coyoteTimeActivated:
			coyoteTimer.start()
			coyoteTimeActivated = true
		# edits the jump height based on when player releases jump key
		if Input.is_action_just_released("jump") or is_on_ceiling():
			velocity.y *= 0.5
		
		gravity = lerp(gravity, maxGravity, 12.0 * delta)
	
	# checks if jump buffer timer is started or not upon jumping
	if Input.is_action_just_pressed("jump"):
		if jumpBufferTimer.is_stopped():
			jumpBufferTimer.start()
	
	# WALL JUMP
	
	# use Global.wallLeniencyColl instead of is_on_wall_only, but breaks, only giving you one wall jump?? try to fix
	if is_on_wall_only() && Global.wallLeniencyColl && velocity.y > -10 && (Input.is_action_pressed("move-left") || Input.is_action_pressed("move-right")):

		# fix wall-sliding in a one-tile wide gap
		if !is_on_wall():
			$AnimatedSprite2D.play("jump")
		elif leftRay.is_colliding():
			velocity.y /= 1.5
			$AnimatedSprite2D.play("wall-slide-left")
		elif rightRay.is_colliding():
			velocity.y /= 1.5
			$AnimatedSprite2D.play("wall-slide-right")
		if Input.is_action_just_pressed("jump") && canWallJump > 0:
			velocity.x = 0
			canWallJump -= 1
			$AnimatedSprite2D.play("jump")
			if leftRay.is_colliding():
				velocity.x = lerp(velocity.x, 400.0, 0.7)
				velocity.y = lerp(velocity.y, -700.0, 0.5)
			elif rightRay.is_colliding():
				velocity.x = lerp(velocity.x, -400.0, 0.7)
				velocity.y = lerp(velocity.y, -700.0, 0.5)
			
	
	
	# checks if jump buffer is running and if either the coyote time is active or player is on the floor
	# if so, performs the jump with animation, and stops all timers to prevent midair jumps
	if !jumpBufferTimer.is_stopped() and (!coyoteTimer.is_stopped() or is_on_floor()):
		velocity.y = jumpHeight
		if wallSlide:
			if is_on_wall() && Input.is_action_pressed("move-right"):
				velocity.x = maxSpeed
			elif is_on_wall() && Input.is_action_pressed("move-left"):
				velocity.x = -maxSpeed
		if velocity.y < 0:
			$AnimatedSprite2D.play("jump")
		jumpBufferTimer.stop()
		coyoteTimer.stop()
		coyoteTimeActivated = true
	
	
	
	
	# CORNER CORRECTION (head nudge)
	# checks if player is trying to reach very high height
	if velocity.y < jumpHeight / 2.0: 
		# array of booleans for if the head nudge ray casts are true
		var headCollision: Array = [$leftHeadNudge.is_colliding(), $leftHeadNudge2.is_colliding(), $rightHeadNudge.is_colliding(), $rightHeadNudge2.is_colliding()]
		# checks if only one boolean is true in the array; corrects x-pos based on which is true
		if headCollision.count(true) == 1:
			# if outer left head nudge is true
			if headCollision[0]:
				global_position.x += 1.75
			if headCollision[2]:
				global_position.x -= 1.75
	
	
	# LEDGE CORRECTION (ledge hop)
	# checks if player has been jumping and moving for enough time to warrant a correction 
	if velocity.y > -30 and velocity.y < 5 and abs(velocity.x) > 3:
		# checks if lower ledge hop is colliding and not the upper one, and if player is moving left
		if $leftLedgeHop.is_colliding() and !$leftLedgeHop2.is_colliding() and velocity.x < 0:
			# gives player a little extra y boost
			velocity.y += jumpHeight / 3.25
		# same logic
		if $rightLedgeHop.is_colliding() and !$rightLedgeHop2.is_colliding() and velocity.x > 0:
			velocity.y += jumpHeight / 3.25
	
	
	
	if velocity.y > 300:
		$AnimatedSprite2D.play("fall")	
	
	if applyGravity:
		velocity.y += gravity
	
	
	move_and_slide()
