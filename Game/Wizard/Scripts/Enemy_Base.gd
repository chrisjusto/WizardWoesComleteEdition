extends KinematicBody2D

export(int) var maxHealth
export(bool) var IdleMovement
export(Vector2) var moveLocation01
export(Vector2) var moveLocation02
export(int) var maxspeed

const up = Vector2(0,-1)
const gravity = 20
const maxfallspeed = 200

enum states {Idle, Walk, inAir, Attack, Hit, Death}
var animStates = states.Idle
var motion = Vector2()
var currentHealth = maxHealth
var movingRight = true
var movingLeft = false


func HandleAnimation():
	match animStates:
		states.Idles:
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

func IdleMovement():
	var position = get_position()
		
	if movingRight == true:
		if position.x <= moveLocation01.x:
			motion.x = maxspeed
		else:
			movingRight = false
			movingLeft = true
	if movingLeft == true:
		if position.x >= moveLocation02.x:
			motion.x = -maxspeed
		else:
			movingLeft = false
			movingRight = true
	pass

func Attack():
	pass

func _ready():
	pass 


func _physics_process(delta):
	if IdleMovement == true:
		IdleMovement()
		
	motion = move_and_slide(motion, up)
		
	$AnimationPlayer.play("Idle")


#if playerlocation.x >= location01
#	move to the location
