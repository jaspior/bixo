extends KinematicBody2D


var pos := Vector2.ZERO
var dir := Vector2.LEFT
var max_dist := 300
var velocity := 100
var lives := 2
var player_pos := Vector2.ZERO

enum states {IDLE, DAMAGE, WAIT, ATTACK}
var state = states.IDLE

func _ready():
	pos = global_position
	
func _process(delta):
	patrol(delta)
	
	
	
func patrol(delta):
	if state == states.IDLE:
		$AnimatedSprite.play("Idle")
		var collision = move_and_collide(velocity*dir*delta)
		if abs(global_position.x - pos.x) > max_dist or collision:
			dir*=-1
			$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
			
			

func _on_HurtBox_area_entered(area):
	if area.is_in_group("attack"):
		hurt()
		

func hurt():
	var last_State = state
	state = states.DAMAGE
	lives -= 1
	move_and_collide(-velocity*dir/10)
	state = last_State
	if lives <= 0:
		queue_free()


func _on_DetectPlayer_body_entered(body):
	if body.name == "Player":
		state = states.WAIT
		$Timer.start()
		player_pos = body.global_position
		$DetectPlayer.set_deferred("monitoring",false)


func _on_Timer_timeout():
	state = states.ATTACK
	var dir_attack = Vector2.LEFT
	$AnimatedSprite.play("Attack")
	if player_pos.x < global_position.x:
		$AnimatedSprite.flip_h = false
		dir_attack*=1
	if player_pos.x > global_position.x:
		$AnimatedSprite.flip_h = true
		dir_attack*=-1
	
	move_and_collide(dir_attack*100)
	$DetectPlayer.set_deferred("monitoring",true)
	state = states.IDLE
