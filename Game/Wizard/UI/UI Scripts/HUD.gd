extends Node2D

onready var Health = get_node("Display/Health")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func UpdateHealth (NewHealth):
	Health.set_frame(NewHealth)

# Called when the node enters the scene tree for the first time.
func _ready():
	UpdateHealth(Global.CurrentHealth)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
