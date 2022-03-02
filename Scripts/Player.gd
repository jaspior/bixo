extends KinematicBody2D


enum states {IDLE, RUNNING, JUMP, FALLING, DASH, WALL, ATTACK}
var state = states.IDLE

export var gravity := 1100
export var speed := 280
export var max_speed := 300
export var friction = 0.8
var velocity := Vector2.ZERO
var canJump : bool
var combo_counter := 0
export var push := 300
export var jump_speedy := 500

func _ready():
	set_animation()
	
func push_movables():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("movable"):
			collision.collider.apply_central_impulse(-collision.normal * push)

func _process(delta):
	
	can_jump()
	apply_gravity(delta)
	jump()
	move(delta)
	wall()
	velocity = move_and_slide(velocity,Vector2.UP,false, 4, PI/4, false)
	set_animation()
	push_movables()

func _input(event):
	if event.is_action_pressed("dash"):
		dash()
	if event.is_action_pressed("attack"):
		attack()

func set_animation():
	match state:
		states.IDLE:
			$AnimatedSprite.play("idle")
		states.RUNNING:
			$AnimatedSprite.play("Run")
		states.FALLING:
			$AnimatedSprite.play("Fall")
		states.JUMP:
			$AnimatedSprite.play("Jump")
		states.WALL:
			$AnimatedSprite.play("Wall")
		states.ATTACK:
			attack_animation()
		_:
			$AnimatedSprite.play("idle")
			print("uer")

func attack_animation():
	match combo_counter:
		1:
			$AnimatedSprite.play("Attack1")
			
		2:
			$AnimatedSprite.play("Attack2")
			
		3:
			$AnimatedSprite.play("Attack3")
			

	
func attack():
	state = states.ATTACK
	combo_counter+=1
	combo_counter = clamp(combo_counter,0,3)
	$ComboTimer.start()
	
	match combo_counter:
		0:
			$Hit1/CollisionShape2D.disabled = true
			$Hit2/CollisionShape2D.disabled = true
			$Hit3/CollisionShape2D.disabled = true
		1:
			$Hit1/CollisionShape2D.disabled = false
			$Hit2/CollisionShape2D.disabled = true
			$Hit3/CollisionShape2D.disabled = true
		2:
			$Hit1/CollisionShape2D.disabled = true
			$Hit2/CollisionShape2D.disabled = false
			$Hit3/CollisionShape2D.disabled = true
		3:
			$Hit1/CollisionShape2D.disabled = true
			$Hit2/CollisionShape2D.disabled = true
			$Hit3/CollisionShape2D.disabled = false
			
		

	if combo_counter == 3:
		yield($AnimatedSprite, "animation_finished")
		combo_counter = 0
		state = states.IDLE
	

func move(delta):
	
	var movement := Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if $AnimatedSprite.flip_h:
		$Hit1.scale.x = 1
		$Hit2.scale.x = 1
		$Hit3.scale.x = 1
	else:
		$Hit1.scale.x = -1
		$Hit2.scale.x = -1
		$Hit3.scale.x = -1
	
	
	if state != states.ATTACK:
		if movement != 0 and state != states.DASH:
			velocity.x += movement*max_speed*delta
			velocity.x = clamp(velocity.x, -speed, speed)
			$AnimatedSprite.flip_h = movement > 0
			if velocity.y == 0 and not is_on_wall():
				state = states.RUNNING
		
			
		else:
			velocity.x = lerp(velocity.x, 0, friction)
			if is_on_floor():
				state = states.IDLE
			
			
####
####  ++++ Inclusão de parâmetros para o ataque também
#### o bixo estava deslizando de mais no meio do ataque 

	else:
		if movement != 0 and state != states.DASH:
			velocity.x += movement*max_speed*delta
			velocity.x = clamp(velocity.x, -speed, speed)
			$AnimatedSprite.flip_h = movement > 0
		else:
			velocity.x = lerp(velocity.x, 0, friction)
	
###
###
###

func jump():
	if Input.is_action_just_pressed("jump") and canJump and state != states.ATTACK:
		velocity.y -= jump_speedy
		state = states.JUMP
	

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y+= gravity*delta

func wall():
	if is_on_wall() and state != states.ATTACK:
		if velocity.y > 30:
			velocity.y = 5	
		elif Input.is_action_just_pressed("jump"):
			velocity.y = - .9 * jump_speedy
			if $AnimatedSprite.flip_h:
				velocity.x = -60
			else:
				velocity.x = 60
		state = states.WALL		

	
func can_jump():
	if velocity.y > 0 and state != states.ATTACK:
		state = states.FALLING
	if is_on_floor():
		canJump = true
	elif canJump and $CoyoteJump.is_stopped():
		$CoyoteJump.start()

func _on_CoyoteJump_timeout():
	canJump = false

func hit_ceiling():
	#avoid animation bug when hit ceiling
	if is_on_ceiling():
		position.y += 1 

func dash():
	state = states.DASH
	var dashed = Vector2.ZERO
	# se aqui usar velocity, o dash é na direção do movimento, não fica egal
	print("dash")
	if $AnimatedSprite.flip_h:
		dashed.x = 100
	else:
		dashed.x = -100
	move_and_collide(dashed,false)

	state = states.IDLE




func _on_ComboTimer_timeout():
	combo_counter = 0
	$Hit1/CollisionShape2D.disabled = true
	$Hit2/CollisionShape2D.disabled = true
	$Hit3/CollisionShape2D.disabled = true
	state = states.IDLE
