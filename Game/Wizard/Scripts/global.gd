extends Node

var player
var CurrentHealth
var Enemies = Array()

func RegisterPlayer(n_player):
	player = n_player

func SetHealth(n_health):
	CurrentHealth = n_health

func ResetEnemies():
	for i in range(0, Enemies.size()):
		Enemies[i].Reset()
		pass
	pass

func _ready():
	pass # Replace with function body.

