extends Character

const jump_velocity = [450,400,350,320,290,250,200,150]
const jump_end_velocity = 150
const wall_jump_velocity_x = [200,100,50,75,220,200,200,0]
const wall_jump_velocity_y = [450,375,250,150,290,250,200,150]

var jump_interval = 0
var wall_slide_interval = 0

# Handles the intial jump input
func _jump_input():
	motion.y = -jump_velocity[0]
	jump_interval += 1
	airiel_action = airiel_states.Jumping

func _ready():
	game_manager._register_player(self)


func _physics_process(delta):
	
	_gravity()
	
	#call the jump input
	if Input.is_action_just_pressed("jump") and state == base_states.On_Ground:
		_jump_input()
		pass
		
	#call movement right and left or return to standing
	if Input.is_action_pressed("right"):
		_horizontal_movement(max_speed)
	elif Input.is_action_pressed("left"):
		_horizontal_movement(-max_speed)
	else:
		_horizontal_movement(0)
		
	#update the players motion variable to be how the character moves
	_update_movement()
	pass
