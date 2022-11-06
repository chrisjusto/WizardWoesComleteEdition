extends CanvasLayer

onready var Animator = get_node("DeathTransition_Rect/AnimationPlayer")
onready var Player = get_node("/root/World/Player")

func DeathAnimation():
	Animator.play("Fade")
	
func StopAnimation():
	Animator.stop(true)
	Animator.play("RESET")


func ResetStuff():
	Player.set_position(Player.CheckpointLocation)
	Player.RotateSprite(Player.isCheckpointRotRight)
	Player.Health = 6
	get_node("/root/World/HUD").UpdateHealth(Player.Health)
	Player.InHitstun = false
	Player.HitstunMovementDisabled = false
	Player.isDead = false
	Global.ResetEnemies()
	
func ResetAnimation():
	Animator.play("RESET")
