extends KinematicBody2D

#constants
const up = Vector2(0, -1)
const gravity = 20
const maxfallspeed = 200
const maxspeed = 100
const jumpvelocity = 300
const jump = [450,400,350,320,290,250,200,150]
const jumpend = 150
#variables
var motion = Vector2()
var isright = true
var jumpincrement = 0
var canjump = true
var activegravity = gravity

onready var wallcheck = get_node("WallCheck")

#Function to move the player left or right
func Move(MaxSpeed, IsRight, Anim):
	motion.x = lerp(motion.x,MaxSpeed,0.05)
	isright = IsRight
	$AnimationPlayer.play(Anim)

#Functionto rotate the player sprite
func RotateSprite (Direction):
	if Direction == true:
		$Sprite.scale.x = 1
		wallcheck.scale.x=1
		isright = true
	else:
		$Sprite.scale.x = -1
		wallcheck.scale.x= -1
		isright = false

#Function to call *Jump*
func Jump ():
	if is_on_floor():
		activegravity = gravity
		if Input.is_action_just_pressed("jump"):
			motion.y = -jump[0]
			jumpincrement = jumpincrement + 1
			canjump = true
	else:
		if canjump == true:
				if Input.is_action_pressed("jump"):
					if jumpincrement < 8:
						motion.y = -jump[jumpincrement]
						jumpincrement = jumpincrement + 1
					else:
						motion.y = -jumpend
						canjump = false
						jumpincrement = 0
				else:
					motion.y = -jumpend
					canjump = false
					jumpincrement = 0
		else:
			WallCheck()
		if motion.y > 0:
			$AnimationPlayer.play("FallIdle")
		else:
			$AnimationPlayer.play("JumpIdle")

func WallCheck ():
	if wallcheck.is_colliding():
		if motion.y > 0:
			activegravity = gravity/10
			if Input.is_action_just_pressed("jump"):
				if isright == true:
					motion.x = -200
					motion.y = -300
					activegravity = gravity
					RotateSprite(false)
				else:
					motion.x = 200
					motion.y = -300
					activegravity =gravity
					RotateSprite(true)
	else:
		activegravity=gravity



####################BEGIN PLAY#############################
func _ready():
	pass 

#####################Event Tick#############################
func _physics_process(delta):

	#sets the gravity
	motion.y += activegravity
	
	#ensures gravity doesnt infinitly increase
	if motion.y > maxfallspeed:
		motion.y = maxfallspeed	
	
	#rotate the sprite
	RotateSprite(isright)
	
	#clamps movement
	motion.x = clamp(motion.x,-maxspeed,maxspeed)
	
	#If Moveinput is pressed call move
	if Input.is_action_pressed("right"):
		Move(maxspeed, true, "Run")
	elif Input.is_action_pressed("left"):
		Move(-maxspeed, false, "Run")
	else:
		motion.x = lerp(motion.x,0,0.2)
		$AnimationPlayer.play("Idle")
	
	Jump()

	motion = move_and_slide (motion,up)

	pass
