extends KinematicBody2D

#constants
const up = Vector2(0, -1)
const gravity = 20
const maxfallspeed = 200
const maxspeed = 100
const jump = [450,400,350,320,290,250,200,150]
const jumpend = 150
const walljumpvelocityX = [300,290,245,220,220,200,200,0]
const walljumpvelocityY = [500,450,400,320,290,250,200,150]
#variables
var motion = Vector2()
var isright = true
var jumpincrement = 0
var canjump = true
var activegravity = gravity
var isonwall = false
var wallslideinterval = 0
var iswalljumping = false
var walljumpincrement = 0
var walljumpjustended = false
onready var wallcheck = get_node("WallCheck")

#Function to move the player left or right
func Move(MaxSpeed, IsRight, Anim):
	if is_on_floor():
		isonwall = false
		motion.x = lerp(motion.x,MaxSpeed,0.05)
		isright = IsRight
		$AnimationPlayer.play(Anim)
	else:
		if iswalljumping == false:
			if isonwall == false:
				if walljumpjustended == true:
					motion.x = lerp(motion.x,MaxSpeed,0.7)
					isright = IsRight
					$AnimationPlayer.play(Anim)
					walljumpjustended = false
				else:
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
func JumpInput():
	motion.y = -jump[0]
	jumpincrement = jumpincrement + 1
	canjump = true

#Function while activly jumping
func Jump ():
	if jumpincrement < 8:
		motion.y = -jump[jumpincrement]
		jumpincrement = jumpincrement + 1
	else:
		JumpEnd()
		
func JumpEnd():
		motion.y = -jumpend
		canjump = false
		jumpincrement = 0
		
func WallslideGravity():
	motion.y = (activegravity/5)+wallslideinterval
	wallslideinterval = wallslideinterval + 2	
func WallCheck ():
	if wallcheck.is_colliding():
		isonwall = true
		$AnimationPlayer.play("WallSlide")
		if motion.y > 0:
			if Input.is_action_just_pressed("jump"):
				WallJumpInput(isright)
	else:
		activegravity=gravity
		isonwall = false
func WallJumpInput (Direction):
	if Direction == true:
		motion.x = walljumpvelocityX[0]
		motion.y = -walljumpvelocityY[0]
		RotateSprite(false)
	else:
		motion.x = -walljumpvelocityX[0]
		motion.y = -walljumpvelocityY[0]
		RotateSprite(true) 
	iswalljumping = true
func WallJump (Direction):
	walljumpincrement = walljumpincrement + 1
	if walljumpincrement < 5:
		if Direction == true:
			motion.x = walljumpvelocityX[walljumpincrement]
			motion.y = -walljumpvelocityY[walljumpincrement]
		else:
			motion.x = -walljumpvelocityX[walljumpincrement]
			motion.y = -walljumpvelocityY[walljumpincrement]
	else:
		iswalljumping = false
		walljumpincrement = 0
		walljumpjustended = true

func Gravity ():
	#wallslide gravity or regular gravity
	if isonwall == true:
		if isright == true:
			if Input.is_action_pressed("right"):
				WallslideGravity()
			else: 
				motion.y += activegravity
		else:
			if Input.is_action_pressed("left"):
				WallslideGravity()
			else:
				motion.y += activegravity			
	else:
		motion.y += activegravity
		wallslideinterval = 0
	#ensure we never fall faster than intended
	if motion.y > maxfallspeed:
		motion.y = maxfallspeed	

func AirAnimation():
	if motion.y > 0:
		$AnimationPlayer.play("FallIdle")
	else:
		$AnimationPlayer.play("JumpIdle")


####################BEGIN PLAY#############################
func _ready():
	pass 

#####################Event Tick#############################
func _physics_process(delta):

	#DO GRAVITY
	Gravity()
	
	#movement
	if Input.is_action_pressed("right"):
		Move(maxspeed, true, "Run")
	elif Input.is_action_pressed("left"):
		Move(-maxspeed, false, "Run")
	else:
		if is_on_floor():
			motion.x = lerp(motion.x,0,0.2)
			$AnimationPlayer.play("Idle")
		else:
			motion.x = lerp(motion.x,0,0.1)

	if is_on_floor():
		RotateSprite(isright)
		motion.x = clamp(motion.x,-maxspeed,maxspeed)
		if Input.is_action_just_pressed("jump"):
			JumpInput()
	else:
		AirAnimation()
		if canjump == false:
			if iswalljumping == false:
				WallCheck()
			else:
				WallJump(isright)
		else:
			if iswalljumping == false:
				if Input.is_action_pressed("jump"):
					Jump()
				else:
					JumpEnd()

	#If Moveinput is pressed call move
	

	#end of tick
	
	motion = move_and_slide (motion,up)

	pass
