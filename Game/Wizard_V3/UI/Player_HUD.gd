extends Node2D

onready var health_ui = $Display/Health
onready var mana_ui = $Display/Mana
onready var game_manager = $"/root/GameManager"

func _update_health(new_health):
	health_ui.set_frame(new_health)
	
func _update_mana(new_mana):
	mana_ui.set_frame(new_mana)
	
func _ready():
	game_manager._register_player_ui(self)
