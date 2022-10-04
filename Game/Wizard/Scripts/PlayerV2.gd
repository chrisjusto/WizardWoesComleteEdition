extends KinematicBody2D

#constants
const up = Vector2(0, -1)
const gravity = 20
const maxfallspeed = 200
const maxspeed = 100
const jump = [450,400,350,320,290,250,200,150]
const jumpend = 150
const walljumpvelocity = Vector2(800,800)
#variables
var motion = Vector2()
var isright = true
var jumpincrement = 0
var canjump = true
var activegravity = gravity
var isonwall = false
var wallslideinterval = 0
var iswalljumping = false
onready var wallcheck = get_node("WallCheck")


func _ready():
	pass # Replace with function body.

func RotateSprite(Direction):
	if Direction == true:
		$Sprite.scale.x = 1
		wallcheck.scale.x=1
		isright = true
	else:
		$Sprite.scale.x = -1
		wallcheck.scale.x= -1
		isright = false

func Gravity():
	pass
	
func 


func _physics_process(delta):
	Gravity()
	
	if is_on_floor():
		RotateSprite(isright)
		if Input.is_action_just_pressed("jump"):
			JumpInput()
