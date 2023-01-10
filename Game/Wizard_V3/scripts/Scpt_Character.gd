extends KinematicBody2D

class_name Character

#enums used in the character logic
enum direction {Right, Left} #used for many things that need to determine direction
enum base_states {On_Ground, In_Air, Dead, Hitstun} #base states for the player
enum ground_states {Idle, Moving, G_Normal_Attack, G_Special_Attack} #possible actions while grounded
enum airiel_states {Jumping, Falling, On_Wall, A_Normal_Attack, A_Special_Attack, Wall_Jumping} #possible actions while in air

#Get References to actors underneath the character class
onready var game_manager = $"/root/GameManager" #reference to the game manager, use to pass things between actors and store variables between scenes
onready var collision = $Collision #the actors collision [hitbox, physics collider etc]
onready var sprite = $Sprite #the actors sprite (this is the thing players see)
onready var animation_player = $Animation_Player #animator
onready var hitstun_timer = $Hitstun_Timer #the length of the characters hitstun
onready var flash_timer = $Flash_Timer #handles the damage FLASHING effect
onready var hitbox_area = $Sprite/Hitbox_Area
onready var hitbox_collision = $Sprite/Hitbox_Area/Hitbox_Collision

#physics constants
const up = Vector2(0,-1) #which direction is up? this direction is up
const gravity = 20 #strength of gravity across all actors
const max_fall_speed = 200 #how fast all actors can fall
const max_speed = 100 #how fast all actors can move

#Designer Set Variables
export(Vector2) var spawn_location #spawn and respawn location should reset be needed
export(direction) var spawn_rotation #spawn and respawn rotation should a reset be needed
export(float) var grounded_acceleration #the speed at which a character can go from standing to max speed
export(float) var airiel_acceleration #the speed at which a character can go from no horizantle arial speed to max speed

#variables used in various functions for base character
var motion = Vector2() #this variable is used to store the movement applied to the character in x and y
var base_action = base_states.On_Ground #what is the characters main state?
var grounded_action = ground_states.Idle #what action is the character currently doing on ground
var airiel_action = airiel_states.Falling #what is the action the character is currently doing in air
var character_horizontal_rotation = direction.Right #what is the characters rotation
var active_gravity = gravity #somethings may change the gravity effecting the character, thats what this variable is for

#movement related functions
#Handle the movement of the character
func _horizontal_movement(speed):
	match base_action:
		base_states.On_Ground: #use grounded acceleration if player is on ground
			motion.x = lerp(motion.x,speed,grounded_acceleration)
		base_states.In_Air:
			
			#wall wall jump acceleration
			if airiel_action == airiel_states.Wall_Jumping:
				motion.x = lerp(motion.x,speed,.75)
			
			#use airiel accelerarion if the player is in air
			else:
				motion.x = lerp(motion.x,speed,airiel_acceleration)
		base_states.Hitstun: #stop movement if player is in hitstun
			motion.x = 0
		base_states.Dead: #stop movement if player is dead
			motion.x = 0

#use this function to actually move the character
func _update_movement():
	motion = move_and_slide(motion,up)

#handle gravity so character falls
func _gravity():
	motion.y += active_gravity
	if motion.y > max_fall_speed:
		motion.y = max_fall_speed

#Handle the rotation of the character
func _rotate_character(character_direction):
	#if the character is doing an attack action, dont rotate the sprite EVER, otherwise, you are free to rotate
	if grounded_action == ground_states.G_Normal_Attack or grounded_action == ground_states.G_Special_Attack or airiel_action == airiel_states.A_Normal_Attack or airiel_action == airiel_states.A_Special_Attack:
		pass
	else:
		match character_direction:
			direction.Right:
				sprite.scale.x = 1
				character_horizontal_rotation = direction.Right
			direction.Left:
				sprite.scale.x = -1
				character_horizontal_rotation = direction.Left

#death related functions
#use this to handle stopping the death animation (this cannot be used to stop other animations as it turns off the sprite)
func _death_animation_end():
	animation_player.stop(true)
	sprite.visible = false

#reset the character to there initial location and rotation
func _reset_character():
	position = spawn_location
	grounded_action = ground_states.Idle
	airiel_action = airiel_states.Falling
	_rotate_character(character_horizontal_rotation)

#simple function to check if character is dead, pass in the current health of the character to see if dead
func _is_dead(health):
	if health <= 0:
		return true
	else:
		return false

#simple function to update the health and trigger the dead state 
func _update_health(damage, health):
	health -= damage
	#if the players health is less than or equal to 0 set them to the dead state
	if health <= 0:
		base_action = base_states.Dead
		return health
	#Otherwise, start the hitstun state
	else:
		base_action = base_states.Hitstun
		hitstun_timer.start()
		_flash()
		return health

#enables the hitbox area
func _enable_hitbox():
	hitbox_area.monitoring = true
	pass

#disable the hitbox area
func _disable_hitbox():
	hitbox_area.monitoring = false
	pass

#function called when the hitbox overlaps with a target, override me in the whatever script inherits from this
func _on_hitbox_entered(body):
	pass # Replace with function body.

#when hitstun ends, revert back to in air or grounded main state (unless of course they are dead)
func _on_Hitstun_Timer_end():
	if base_action == base_states.Hitstun:
		if is_on_floor():
			base_action = base_states.On_Ground
			grounded_action = ground_states.Idle
			airiel_action = airiel_states.Falling
		else:
			base_action = base_states.In_Air
			grounded_action = ground_states.Idle
			airiel_action = airiel_states.Falling

#function to flash the player sprite [for when the player gets hit]
func _flash():
	sprite.material.set_shader_param("flash_modifier",0)
	flash_timer.start()

#ends the flashing of the character when they get hit/while they are in hitstun
func _on_Flash_Timer_end():
	sprite.material.set_shader_param("flash_modifier",0)
	pass # Replace with function body.

func _play_animation(animation_name):
	animation_player.play(animation_name)

func _animation_manager():
	if base_action == base_states.On_Ground:
		match grounded_action:
			ground_states.Idle:
				_play_animation("Idle")
			ground_states.Moving:
				_play_animation("Walk")
			ground_states.G_Normal_Attack:
				_play_animation("N_Attack")
			ground_states.G_Special_Attack:
				_play_animation("S_Attack")
	elif base_action == base_states.In_Air:
		match airiel_action:
			airiel_states.Falling:
				_play_animation("Fall")
			airiel_states.Jumping:
				_play_animation("Jump")
			airiel_states.On_Wall:
				_play_animation("Wall_Slide")
	pass

func _on_ground():
	if base_action == base_states.Hitstun or base_action == base_states.Dead:
		pass
	else:
		if is_on_floor() == true:
			base_action = base_states.On_Ground
		else:
			base_action = base_states.In_Air

