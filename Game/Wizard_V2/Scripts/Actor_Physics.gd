extends KinematicBody2D

class_name Actor

const up = Vector2(0,-1)
const max_fall_speed = 200


#public variables
export(int) var gravity = 20
export(int) var max_health = 1
export(int) var max_speed = 100


#internal variables
var motion = Vector2()
var is_dead = false
var current_health

func is_dead(health):
	



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
