extends KinematicBody2D


enum states {IDLE, RUNNING, JUMP, FALLING, DASH, WALL}
var state = states.IDLE

var gravity := 300
var speed := 150
var max_speed := 300
var friction = 0.5
var velocity := Vector2.ZERO
var canJump : bool


func _ready():
	set_animation()

func _process(delta):
	
	can_jump()
	apply_gravity(delta)
	jump()
	move(delta)
	wall()
	velocity = move_and_slide(velocity,Vector2.UP)
	set_animation()

func _input(event):
	if event.is_action_pressed("dash"):
		dash()

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
		_:
			$AnimatedSprite.play("idle")
			print("uer")
		
func move(delta):
	
	var movement := Input.get_action_strength("right") - Input.get_action_strength("left")
	
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
		
	
func jump():
	if Input.is_action_just_pressed("jump") and canJump:
		velocity.y -= 250
		state = states.JUMP
	

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y+= gravity*delta

func wall():
	if is_on_wall():
		if velocity.y > 30:
			velocity.y = 5	
		elif Input.is_action_just_pressed("jump"):
			velocity.y = -200	
			if $AnimatedSprite.flip_h:
				velocity.x = -100
			else:
				velocity.x = 100
		state = states.WALL		

	
func can_jump():
	if velocity.y > 0:
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
	move_and_collide(dashed)

	state = states.IDLE
