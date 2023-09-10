extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if !Global.is_attacking || !Global.is_climbing:
		player_animations()

#animations
func player_animations():
	#on left (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_left") && !Global.is_jumping:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 7
	#on right (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_right") && !Global.is_jumping:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = -7
	#on idle if nothing is being pressed
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")

func _input(_event):
	#on attack
	if Input.is_action_just_pressed("ui_attack"):
		Global.is_attacking = true
		$AnimatedSprite2D.play("attack")
	# Handle Jump.
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")
		Global.is_jumping = true
	# Climbing
	if Global.is_climbing == true:
		if Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("climb")
			gravity = 100
			velocity.y = -200
	else:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
		Global.is_climbing = false
		Global.is_jumping = false


func _on_animated_sprite_2d_animation_finished():
	Global.is_attacking = false
	Global.is_climbing = false
