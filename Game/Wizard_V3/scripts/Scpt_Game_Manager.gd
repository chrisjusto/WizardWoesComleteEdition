extends Node

class_name Game_Manager

const player_max_health = 6
const player_max_mana = 6


var player
var player_current_health = 0
var player_current_mana = 0
var enemies = Array()
var player_hud


#Register player reference in the global script
func _register_player(n_player):
	player = n_player
	
# Registers Enemy reference in the global script
func _register_enemy(n_enemy):
	enemies.append(n_enemy)
	
# Updates the players current health
func _set_health(n_health):
	player_current_health = n_health
	player_hud._update_health(player_current_health)	

# Updates the players current mana
func _set_mana(n_mana):
	player_current_mana = n_mana
	player_hud._update_mana(player_current_mana)
	
# Resets the enemies in the current level
func _reset_enemies():
	for i in range(0, enemies.size()):
		enemies[i]._reset()

# UI calls this function when it begins, registering the UI for future functions and updates the health
func _register_player_ui(ui_reference):
	player_hud = ui_reference
	player_hud._update_health(player_current_health)
	player_hud._update_mana(player_current_mana)

# Clear referenced enemies on stage clear
func _clear_enemies():
	enemies.clear()

func _reset_level():
	_reset_enemies()
	_set_health(player_max_health)
	_set_mana(player_max_mana)
	player._reset_character()

# On new level initialization, set player health and junk
func _ready():
	player_current_health = player_max_health
	player_current_mana = player_max_mana


