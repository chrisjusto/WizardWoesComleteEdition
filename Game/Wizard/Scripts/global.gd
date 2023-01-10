extends Node

const startinghealth = 6

var player
var p_maxhealth
var p_currenthealth
var Enemies = Array()

func RegisterPlayer(n_player):
	player = n_player

func SetHealth(n_health):
	p_currenthealth = n_health

func ResetEnemies():
	for i in range(0, Enemies.size()):
		Enemies[i].Reset()
		pass
	pass

func _ready():
	#starting player HP
#	if p_currenthealth <= 0:
#		p_currenthealth = p_maxhealth
#	p_maxhealth = startinghealth
	pass # Replace with function body.

