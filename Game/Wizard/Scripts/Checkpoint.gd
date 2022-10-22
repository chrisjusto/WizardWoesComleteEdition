extends Area2D

export(Vector2) var RespawnLocation
export(bool) var RespawnRotationRight

		



func _on_Checkpoint_body_entered(body):
	if "Player" in body.name:
		body.CheckpointLocation = RespawnLocation
		body.isCheckpointRotRight = RespawnRotationRight
		$Sprite.frame = 1

