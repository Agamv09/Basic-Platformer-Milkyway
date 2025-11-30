extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() || !coyote_timer.is_stopped()):
		velocity.y = JUMP_VELOCITY

	#Gets input direction: -1, 0 or 1
	var direction := Input.get_axis("Move_left", "Move_right")
	
	#Flip the sprite
	if direction > 0:
		animated_sprite2D.flip_h = false
	elif direction < 0:
		animated_sprite2D.flip_h = true
		
	#Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite2D.play("Idle")
		else:
			animated_sprite2D.play("Run")
	else:
		animated_sprite2D.play("Jump")
	
	#Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	var was_on_floor = is_on_floor

	if was_on_floor && !is_on_floor():
		coyote_timer.start()
