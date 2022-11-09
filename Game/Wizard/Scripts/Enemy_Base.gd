extends KinematicBody2D

export(bool) var IdleMovement
export(bool) var HasActiveAttack
export(Vector2) var moveLocation01
export(Vector2) var moveLocation02
export(int) var maxspeed
export(int) var holdTime
export(int) var Damage
export(int) var PreAttackWait
export(int) var PostAttackWait
export(int) var MaxHealth

const up = Vector2(0,-1)
const gravity = 20
const maxfallspeed = 200
const hitstunLength = 60

enum states {Idle, Walk, inAir, Attack, Hit, Death, IdleUnnoticed, Notice}
var animStates = states.Idle
var motion = Vector2()
var movingRight = true
var movingLeft = false
var idle = true
var aggroed = false
var noticed = false
var isAttacking = false
var AttackEnd = false
onready var SpawnLocation = position
var currentHoldTime = 0
onready var hitbox = get_node("Sprite/Hit_Area") 
onready var hitrange = get_node("Sprite/HitRange_Area")
onready var timer = get_node("Fash_Timer")
var AttackTarget
var WaitTimer = 0
var health = 0
var hitstunActive = false
var isDead = false



func Reset(): #When player dies, this gets called to reset me
	aggroed = false
	noticed = false
	motion = move_and_slide(Vector2(0,0), up)
	idle = true
	set_collision_layer_bit(2, true)
	position = SpawnLocation
	currentHoldTime = 0
	health = MaxHealth
	var sprite = get_node("Sprite")
	sprite.visible = true
	isDead = false
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
func EnemyIdleMovement(): #this is what I do when its time to FIIIIIIGHT
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
	isAttacking = true
	animStates = states.Attack
	
	pass
	
func flash():
	$Sprite.material.set_shader_param("flash_modifier", 1)
	timer.start()
	

func _ready():
	Global.Enemies.append(self)
	health = MaxHealth
	if HasActiveAttack == false:
		hitrange.monitoring = false
	pass 

func _physics_process(delta):

	if isDead == true:
		animStates = states.Death
		HandleAnimation()
		pass
	else:
		if hitstunActive == false:
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
								if AttackTarget == null and isAttacking == false:
								#if isAttacking == false:
									EnemyIdleMovement()
								else:
									motion.x = 0
									motion.y = 0
									if AttackEnd == true:
										if PostAttackWait == 0:
											AttackEnd = false
											isAttacking = false
											WaitTimer = 0
										else:
											WaitTimer += 1
											if WaitTimer > PostAttackWait:
												AttackEnd = false
												isAttacking = false
												WaitTimer = 0
											else:
												animStates = states.Idle
									else:
										if isAttacking == false:
											if PreAttackWait == 0:
												WaitTimer = 0
												Attack()
											else:
												WaitTimer += 1
												if WaitTimer > PreAttackWait:
													WaitTimer = 0
													Attack()
				HandleAnimation()
				motion = move_and_slide(motion, up)
			else:
				currentHoldTime = currentHoldTime + 1
		else:
			animStates = states.Hit
			HandleAnimation()
			if WaitTimer > hitstunLength:
				isAttacking = false
				AttackEnd = false
				hitstunActive = false
			else:
				WaitTimer += 1
			pass

func ActivateHitbox():
	hitbox.monitoring = true
func DisableHitbox():
	hitbox.monitoring = false
func EndAttack():
	AttackEnd = true


#hitbox
func _on_Hit_Area_body_entered(body):
	if "Player" in body.name:
		body.Health = body.Health - Damage
		get_node("/root/World/HUD").UpdateHealth(body.Health)
		body.Hitstun()
	pass # Replace with function body.

####Detect if player is in range for active attack####
func _on_HitRange_Area_body_entered(body):
	if "Player" in body.name:
		AttackTarget = body
	pass # Replace with function body.

func _on_HitRange_Area_body_exited(body):
	if "Player" in body.name:
		AttackTarget = null
	pass # Replace with function body.

func Death():
	set_collision_layer_bit(2, false)
	DisableHitbox()
	AttackTarget = null
	animStates = states.Death
	isDead = true
	pass
	
func StopAnimations():
	$AnimationPlayer.stop(true)
	var Sprite = get_node("Sprite")
	Sprite.visible = false

func Hitstun(incoming_damage):
	health = health - incoming_damage
	if health < 0:
		Death()
	else:
		flash()


func _on_Fash_Timer_timeout():
	$Sprite.material.set_shader_param("flash_modifier", 0)	
	pass # Replace with function body.
