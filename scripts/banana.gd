extends RigidBody2D

func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	print("Banana has left the area")
	
#func _process(_delta):
#	if RigidBody2D(linear_velocity < 150):
#		RigidBody2D.linear_velocity = linear_velocity.normalized()
