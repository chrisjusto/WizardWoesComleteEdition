extends Area2D

export(int) var Damage

func _ready():
	pass 




func _on_Area2D_body_entered(body):
	if "Player" in body.name:
		if body.InHitstun == false:
			body.Health = body.Health - Damage
			get_node("/root/World/HUD").UpdateHealth(body.Health)
			body.Hitstun()
	pass # Replace with function body.
