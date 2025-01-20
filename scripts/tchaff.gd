extends Area2D

signal died
signal hit(hp)
signal respawn(hp)
var hp : int = 3

@export var speed = 400 # How fast Tchaff moves
var screen_size # Size of the game window

func _ready():
	screen_size = get_viewport_rect().size
	$AnimationPlayer.play("RESET") # reset animation states
	$AnimatedSprite2D.play() # start wobbling

func _on_body_entered(_body: Node2D) -> void:
	hp -= 1
	hit.emit(hp)
	$DeathMihh.play()
	$AnimatedSprite2D.pause() # get bamboozled into no wobble
	$AnimationPlayer.play("HitAnimation")
	if hp == 0:
		died.emit()
		$AnimationPlayer.play("DeathAnimation")
	else:
		$AnimationPlayer.queue("RESET") # queue reset animation states

# Gives the player 1.5s of invulnerability after being hit
func _on_hit(_hp) -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	if hp > 0:
		await get_tree().create_timer(1.5).timeout
		$CollisionShape2D.disabled = false
		$AnimatedSprite2D.play() # resume wobbles

func start(pos):
	position = pos
	hp = 3
	$AnimationPlayer.play("RESET") # reset animation states
	$CollisionShape2D.disabled = false # reenable hitbox
	$AnimatedSprite2D.play() # start wobbling
	respawn.emit(hp)

func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	$AnimatedSprite2D.rotation_degrees = 0 # Reset rotation

	if velocity.y < 0 and velocity.x == 0: # if moving up, but not left/right
		$AnimatedSprite2D.animation = "wobble_up" # use up animation
	elif velocity.y > 0 and velocity.x == 0: # if moving down, but not left/right
			$AnimatedSprite2D.animation = "wobble_down" # use down animation
	else:
		if velocity.x < 0: # if moving left
			$AnimatedSprite2D.animation = "wobble_left" # use left animation
			if velocity.y > 0: # if also moving down
				$AnimatedSprite2D.rotation_degrees = -45 # rotate sprite down left
			elif velocity.y < 0: # if also moving up
				$AnimatedSprite2D.rotation_degrees = +45 # rotate sprite up left
		elif velocity.x > 0: # if moving right
			$AnimatedSprite2D.animation = "wobble_right" # use right animation
			if velocity.y > 0: # if also moving down
				$AnimatedSprite2D.rotation_degrees = +45 # rotate sprite down right
			elif velocity.y < 0: # if also moving up
				$AnimatedSprite2D.rotation_degrees = -45 # rotate sprite up right
