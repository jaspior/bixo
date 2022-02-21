extends RigidBody2D

var lives := 3


func _ready():
	$AnimatedSprite.play("Idle")


func _on_Hurt_area_entered(area):
	if area.is_in_group("attack"):
		lives -= 1
		$AnimatedSprite.play("Damage")
		yield($AnimatedSprite,"animation_finished")
		$AnimatedSprite.play("Idle")
		if lives <= 0:
			$AnimatedSprite.play("Break")
			yield($AnimatedSprite,"animation_finished")
			queue_free()
