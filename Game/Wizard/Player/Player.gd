extends KinematicBody2D

#constants
const up = Vector2(0, -1)
const gravity = 20
const maxfallspeed = 200
const maxspeed = 100
const jump = [450,400,350,320,290,250,200,150]
const jumpend = 150
const walljumpvelocityX = [200,100,50,75,220,200,200,0]
const walljumpvelocityY = [450,375,250,150,290,250,200,150]
const HitstunLength = 20
const MaxHealth = 6
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
var lockmovement = false
var wallgraceperiod = 0
var wallanimationplaying = false
onready var wallcheck = get_node("WallCheck")
onready var Animator = get_node("AnimationPlayer")
onready var CeilingCheck = get_node("CeilingCheck")
onready var PlayerSprite = get_node("Sprite")
onready var DeathUI = get_node("/root/World/DeathTransition")
enum States {Idle, Walking, OnWall, Jumping, Falling, Dead, Attack}
var AnimState = States.Idle
var Health = 6
var InHitstun = false
var HitstunIncrement = 0
var SpriteVisible = true
var isDead = false
var isAttacking = false
export(Vector2) var CheckpointLocation
export(bool) var isCheckpointRotRight

#####################################################################
#Movement
func Move(MaxSpeed, IsRight):
	if is_on_floor():
		isonwall = false
		motion.x = lerp(motion.x,MaxSpeed,0.05)
		isright = IsRight
		AnimState = States.Walking
	else:
		if isonwall == false:
			if iswalljumping == false:
				motion.x = lerp(motion.x,MaxSpeed,0.05)
				isright = IsRight
			else:
				if lockmovement == false:
					motion.x = lerp(motion.x, MaxSpeed, .75)
					isright=IsRight
#Animation Stuff
func RotateSprite (Direction):
	if Direction == true:
		$Sprite.scale.x = 1
		wallcheck.scale.x=1
		isright = true
	else:
		$Sprite.scale.x = -1
		wallcheck.scale.x= -1
		isright = false
func AirAnimation():
	if motion.y > 0:
		if isonwall == false:
			AnimState = States.Falling
	else:
		AnimState = States.Jumping
#Jump stuff
func JumpInput():
	motion.y = -jump[0]
	jumpincrement = jumpincrement + 1
	canjump = true
func Jump ():
	if CeilingCheck.is_colliding(): #Bonk check goes here
		JumpEnd(0)
	else:
		if jumpincrement < 8:
			motion.y = -jump[jumpincrement]
			jumpincrement = jumpincrement + 1
		else:
			JumpEnd(-jumpend)
func JumpEnd(Direction):
		motion.y = Direction
		canjump = false
		jumpincrement = 0
#Walljump Shit
func WallslideGravity():
	motion.y = (activegravity/5)+wallslideinterval
	wallslideinterval = wallslideinterval + 2	
func WallCheck ():
	if wallcheck.is_colliding():
		if iswalljumping == false:
			if isright == true:
				if Input.is_action_pressed("right"):
					isonwall = true
					if motion.y > 0:
						if Input.is_action_just_pressed("jump"):
							WallJumpInput(isright)
							isonwall = false
				else:
					if isonwall == true:
						if wallgraceperiod < 7:
							wallgraceperiod = wallgraceperiod + 1
							if Input.is_action_just_pressed("jump"):
								WallJumpInput(isright)
								isonwall = false
						else:
							isonwall = false
							activegravity = gravity
			else:
				if Input.is_action_pressed("left"):
					isonwall = true
					if motion.y > 0:
						if Input.is_action_just_pressed("jump"):
							WallJumpInput(isright)
							isonwall = false
				else:
					if isonwall == true:
						if wallgraceperiod < 7:
							wallgraceperiod = wallgraceperiod + 1
							if Input.is_action_just_pressed("jump"):
								WallJumpInput(isright)
								isonwall = false
						else:
							isonwall = false
							activegravity = gravity
		else:
			activegravity=gravity
			isonwall = false
	else:
		activegravity=gravity
		isonwall = false
func WallJumpInput (Direction):
	if Direction == true:
		motion.x = walljumpvelocityX[0]
		motion.y = -walljumpvelocityY[0]
	else:
		motion.x = -walljumpvelocityX[0]
		motion.y = -walljumpvelocityY[0]
	iswalljumping = true
func WallJump (Direction):
	walljumpincrement = walljumpincrement + 1
	if walljumpincrement < 8:
		if Direction == true:
			if walljumpincrement < 3:
				lockmovement = true
				motion.x = walljumpvelocityX[walljumpincrement]
			else:
				lockmovement = false
			motion.y = -walljumpvelocityY[walljumpincrement]
		else:
			if walljumpincrement < 3:
				motion.x = -walljumpvelocityX[walljumpincrement]
				lockmovement = true
			else:
				lockmovement = false
			motion.y = -walljumpvelocityY[walljumpincrement]
	else:
		iswalljumping = false
		walljumpincrement = 0
#gravity shit
func Gravity ():
	#wallslide gravity or regular gravity
	if isonwall == true:
		motion.y = (activegravity/5)+wallslideinterval
		wallslideinterval = wallslideinterval + 2
	else:
		motion.y += activegravity
		wallslideinterval = 0
		wallgraceperiod = 0
	#ensure we never fall faster than intended
	if motion.y > maxfallspeed:
		motion.y = maxfallspeed	
#Handles them Animations
func HandleAnimation ():
	if isAttacking == false:
		match AnimState:
			States.Idle:
				Animator.play("Idle")
			States.Walking:
				Animator.play("Run")
			States.OnWall:
				Animator.play("wall")
			States.Jumping:
				Animator.play("JumpIdle")
			States.Falling:
				Animator.play("FallIdle")
			States.Dead:
				Animator.play("Death")
			States.Attack:
				Animator.play("NormalAttack")
	else:
		Animator.play("NormalAttack")
			
func Attack():
	AnimState = States.Attack
	
func EndAttack():
	isAttacking = false

func Hitstun():
	if InHitstun == false:
		InHitstun = true
		if isright == true:
			motion.x = -200
			motion.y = -300
		else:
			motion.x = 200
			motion.y = -300
			pass
			
func HitstunActive():
	if HitstunIncrement < HitstunLength:
		HitstunIncrement = HitstunIncrement + 1
		if HitstunIncrement == 5 or 10 or 15:
			if SpriteVisible == false:
				SpriteVisible = true
				PlayerSprite.visible = true
			else: 
				SpriteVisible = false
				PlayerSprite.visible = false
	else:
		PlayerSprite.visible = true
		InHitstun = false
		HitstunIncrement = 0

func Death():
	isDead = true
	$AnimationPlayer.stop(true)
	DeathUI.DeathAnimation()

####################BEGIN PLAY#############################
func _ready():
	Global.SetHealth(Health)
	pass 

#####################Event Tick#############################
func _physics_process(_delta):
	#DO GRAVITY
	Gravity()
	

	
	#movement
	if Health < 1:
		if isDead == false:
			motion = move_and_slide (Vector2(0,0),Vector2(0,0))
			AnimState = States.Dead
			HandleAnimation()
		else:
			pass
	else:
		#MOVEMENT
		if Input.is_action_pressed("right"): #Move Right
			Move(maxspeed, true)
		elif Input.is_action_pressed("left"): #Move Left
			Move(-maxspeed, false)
		else: #lerp to not moving
			if is_on_floor():
				motion.x = lerp(motion.x,0,0.2)
				AnimState = States.Idle
			else:
				motion.x = lerp(motion.x,0,0.1)
		RotateSprite(isright) #Rotate the orientation of player
		
		if Input.is_action_just_pressed("attack"):
			if isAttacking == false:
				isAttacking = true
				Attack()
				AnimState = States.Attack
		else:
		#handle ground vs air logic
			if is_on_floor():
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
							JumpEnd(-jumpend)
			
			#if on wall do wall animation
			if isonwall ==true:
				AnimState = States.OnWall
			
		if InHitstun == true:
			HitstunActive()
		#Update Animations	

		HandleAnimation()
		
		#move dat player
		motion = move_and_slide (motion,up)

	pass
