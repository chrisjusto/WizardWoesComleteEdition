extends KinematicBody2D

export(int) var maxHealth
export(bool) var IdleMovement
export(Vector2) var moveLocation01
export(Vector2) var moveLocation02
export(int) var maxspeed
export(int) var holdTime

const up = Vector2(0,-1)
const gravity = 20
const maxfallspeed = 200

enum states {Idle, Walk, inAir, Attack, Hit, Death, IdleUnnoticed, Notice}
var animStates = states.Idle
var motion = Vector2()
var currentHealth = maxHealth
var movingRight = true
var movingLeft = false
var idle = true
var aggroed = false
var noticed = false
onready var SpawnLocation = position
var currentHoldTime = 0

func Reset(): #When player dies, this gets called to reset me
	aggroed = false
	noticed = false
	motion = move_and_slide(Vector2(0,0), up)
	idle = true
	position = SpawnLocation
	currentHoldTime = 0
func _on_Area2D_body_entered(body): #when player enters my "Notice me sempai" range notice Animation
	if currentHoldTime >= holdTime:
		if "Player" in body.name:
			noticed = true
			idle = false
func NoticePlayerEnd(): #when I'm done noticing sempai its time to FIGHT
	aggroed = true
	#$Area2D.monitoring = false
	pass
func HandleAnimation(): #ANIMATION STATE MACHINE
	match animStates:
		states.Idle:
			$AnimationPlayer.play("Idle")
		states.Walk:
			$AnimationPlayer.play("Walk")
		states.inAir:
			$AnimationPlayer.play("inAir")
		states.Attack:
			$AnimationPlayer.play("Attack")
		states.Death:
			$AnimationPlayer.play("Death")
		states.Hit:
			$AnimationPlayer.play("Hit")
		states.IdleUnnoticed:
			$AnimationPlayer.play("IdleUnnoticed")
		states.Notice:
			$AnimationPlayer.play("Notice")
func NoticePlayer(): #This is the function that gets called when sempai is noticed
	animStates = states.Notice
	pass
func IdleMovement(): #this is what I do when its time to FIIIIIIGHT
	var position = get_position()
		
	if movingRight == true:
		if position.x <= moveLocation02.x:
			motion.x = maxspeed
			animStates = states.Walk
			$Sprite.scale.x = -1
			#print(position.x)
			#print(moveLocation01.x)
		else:
			movingRight = false
			movingLeft = true
			#print("ELSE")
	if movingLeft == true:
		if position.x >= moveLocation01.x:
			motion.x = -maxspeed
			animStates = states.Walk
			$Sprite.scale.x = 1
			#print(position.x)
			#print(moveLocation02.x)
		else:
			movingLeft = false
			movingRight = true
			#print("ELSE")
func Attack(): #call me to attack [this is placeholder RN]
	pass

func _ready():
	Global.Enemies.append(self)
	pass 

func _physics_process(delta):

	if currentHoldTime > holdTime:
		if idle == true:	
			animStates = states.IdleUnnoticed
			pass
		else:
			if noticed == true:
				if aggroed == false:
					NoticePlayer()
				else:
					if IdleMovement == true:
						IdleMovement()
		HandleAnimation()
		motion = move_and_slide(motion, up)
	else:
		currentHoldTime = currentHoldTime + 1
