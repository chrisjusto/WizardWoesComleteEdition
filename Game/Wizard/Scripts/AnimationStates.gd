extends AnimationPlayer


enum States {Idle, Walking, OnWall, Jumping, Falling}
# Declare member variables here. Examples:
var AnimationState = States.Idle# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


#func _physics_process(delta):
#	match AnimationState:
#		States.Idle:
#			print("idle")
#		States.Walking:
#			print("walking")
#		States.OnWall:
#			print("onwall")
#		States.Jumping:
#			print("Jumping")
#		States.Falling:
#			print("Falling")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
