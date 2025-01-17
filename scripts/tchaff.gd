extends Area2D

signal hit

@export var speed = 400 # How fast Tchaff moves
var screen_size # Size of the game window

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
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

func _on_body_entered(_body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit() # scream in death pain and anguish at whoever listens
	# Must be deferred as we can't change physics properties on a physics callback
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.animation = "wobble_down" # reset to down animation
	$AnimatedSprite2D.play()
