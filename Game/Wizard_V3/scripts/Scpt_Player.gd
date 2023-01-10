extends Character

const jump_velocity = [300,250,200,150,125,115,110,105]
#[450,400,350,320,290,250,200,150]
#[150,200,250,290,320,350,400,450]
const jump_end_velocity = 150
const wall_jump_velocity_x = [200,100,50,75,220,200,200,0]
const wall_jump_velocity_y = [450,375,250,150,290,250,200,150]

var jump_interval = 0
var wall_jump_interval = 0
var wall_slide_interval = 0
var wall_jump_buffer_active = false
var lock_movement = false

onready var ceiling_check = $Ceiling_RayCast
onready var wall_check = $Wall_RayCast
onready var wall_jump_buffer_timer = $Wall_Jump_Buffer_Timer

# Handles the intial jump input
func _jump_input():
	motion.y = -jump_velocity[0]
	jump_interval += 1
	airiel_action = airiel_states.Jumping

#handle while jumping
func _jump_action():
	if ceiling_check.is_colliding():
		motion.y = 0
		jump_interval = 0
		airiel_action = airiel_states.Falling
	elif jump_interval <= jump_velocity.size()-1:
		motion.y= -jump_velocity[jump_interval]
		jump_interval += 1
	else:
		_jump_end()
		pass

#end the jumping process and transition the player to falling
func _jump_end():
	motion.y = -jump_end_velocity
	jump_interval = 0
	airiel_action = airiel_states.Falling
	pass

func _rotate_wallcheck(Direction):
	match Direction:
		direction.Right:
			wall_check.scale.x = 1
		direction.Left:
			wall_check.scale.x = -1

#slide down the wall
func _wall_slide():
	airiel_action = airiel_states.On_Wall
	motion.y = (active_gravity/5)+wall_slide_interval
	wall_slide_interval += 2
	
#when the buffer period ends, turn off the wall_jump_buffer_active
func _on_Wall_Jump_Buffer_Timer_timeout():
	print("timeout")
	airiel_action = airiel_states.Falling
	wall_jump_buffer_active = false

#start my wall jumping
func _wall_jump_input(player_direction):
	if player_direction == direction.Right:
		motion.x = wall_jump_velocity_x[wall_jump_interval]
	elif player_direction == direction.Left:
		motion.x = -wall_jump_velocity_x[wall_jump_interval]
	motion.y = -wall_jump_velocity_y[wall_jump_interval]
	airiel_action = airiel_states.Wall_Jumping

#Wall Jump Logic
func _wall_jump_action(player_direction):

	#increment wall jump
	wall_jump_interval += 1
	
	#if I should be wall jumping im going to be doing it
	if wall_jump_interval < (wall_jump_velocity_x.size()-1):
		
		#if im less than halfway through my wall jump, lock my movement
		if wall_jump_interval < (wall_jump_velocity_x.size()-1)/2:
			lock_movement = true
		else:
			lock_movement = false
			
		#set my X and Y velocity for the jump
		motion.y = -wall_jump_velocity_y[wall_jump_interval]
		if player_direction == direction.Right:
			motion.x = wall_jump_velocity_x[wall_jump_interval]
		elif player_direction == direction.Left:
			motion.x = -wall_jump_velocity_x[wall_jump_interval]
	
	#if I shouldn't be wall jumping revert my state to falling and reset the interval 
	else:
		airiel_action = airiel_states.Falling
		wall_jump_interval = 0
	pass

# ready function
func _ready():
	#register player with the game manager
	game_manager._register_player(self)

#do tick logic
func _physics_process(delta):
	
	_gravity()
	_on_ground()
	#call the jump input
	if Input.is_action_just_pressed("jump") and base_action == base_states.On_Ground:
		_jump_input()

	#if player is jumping, then continue jumping, or end the jump function
	if base_action == base_states.In_Air and airiel_action == airiel_states.Jumping:
		if Input.is_action_pressed("jump"):
			_jump_action()
		else:
			_jump_end()

	#If I am falling, am I close enough to a wall to wall slide
	if base_action == base_states.In_Air and airiel_action == airiel_states.Falling:
		if wall_check.is_colliding():
			if Input.is_action_pressed("right") and character_horizontal_rotation == direction.Right:
				_wall_slide()
			elif Input.is_action_pressed("left") and character_horizontal_rotation == direction.Left:
				_wall_slide()
		else: 
			wall_slide_interval = 0
	elif base_action == base_states.In_Air and airiel_action == airiel_states.On_Wall:
		if wall_check.is_colliding():
			if Input.is_action_pressed("right") and character_horizontal_rotation == direction.Right:
				_wall_slide()
			elif Input.is_action_pressed("left") and character_horizontal_rotation == direction.Left:
				_wall_slide()
			else:
				if wall_jump_buffer_active == false:
					wall_jump_buffer_timer.start()
					wall_jump_buffer_active = true
	else:
		wall_slide_interval = 0

	if Input.is_action_just_pressed("jump") and airiel_action == airiel_states.On_Wall:
		_wall_jump_input(character_horizontal_rotation)
		
	if Input.is_action_just_pressed("jump") and wall_jump_buffer_active == true:
		_wall_jump_input(character_horizontal_rotation)

	if airiel_action == airiel_states.Wall_Jumping:
		_wall_jump_action(character_horizontal_rotation)
	
		
	#call movement right and left or return to standing
	if Input.is_action_pressed("right") and lock_movement == false:
		_horizontal_movement(max_speed)
		_rotate_character(direction.Right)
		_rotate_wallcheck(direction.Right)
		grounded_action = ground_states.Moving
	elif Input.is_action_pressed("left") and lock_movement == false:
		_horizontal_movement(-max_speed)
		_rotate_character(direction.Left)
		_rotate_wallcheck(direction.Left)
		grounded_action = ground_states.Moving
	elif lock_movement == true:
		pass
	else:
		_horizontal_movement(0)
		grounded_action = ground_states.Idle
	#update the players motion variable to be how the character moves
	_animation_manager()
	_update_movement()
	pass



