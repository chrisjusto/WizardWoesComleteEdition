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
	
func _jump_action():
	if jump_interval <= jump_velocity.size()-1:
		motion.y= jump_velocity[jump_interval]
		jump_interval += 1
	else:
		pass

func _jump_end():
	motion.y = jump_end_velocity
	jump_interval = 0
	airiel_action = airiel_states.Falling
	pass
	

func _ready():
	game_manager._register_player(self)


func _physics_process(delta):
	
	_gravity()
	
	#call the jump input
	if Input.is_action_just_pressed("jump") and base_action == base_states.On_Ground:
		_jump_input()
		base_action = base_states.In_Air
		airiel_action = airiel_states.Jumping
		pass
	
	if airiel_action == airiel_states.Jumping:
		_jump_action()
		
	#call movement right and left or return to standing
	if Input.is_action_pressed("right"):
		_horizontal_movement(max_speed)
		_rotate_character(direction.Right)
		grounded_action = ground_states.Moving
	elif Input.is_action_pressed("left"):
		_horizontal_movement(-max_speed)
		_rotate_character(direction.Left)
		grounded_action = ground_states.Moving
	else:
		_horizontal_movement(0)
		grounded_action = ground_states.Idle
	#update the players motion variable to be how the character moves
	_animation_manager()
	_update_movement()
	pass
