extends Node

@export var mob_scene : PackedScene

var score

func _ready():
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	print("Game over") # For testing purposes to see if/when code breaks clearer

func newGame():
	score = 0
	$tchaff.start($StartPos.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("prepar for... BANAN")
	get_tree().call_group("bananas", "queue_free")
	print("Threw the bananas out and started a new game") # For testing purposes to see if/when code breaks clearer

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate() # New mob scene instance

	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf() # Make random spawnspot

	var direction = mob_spawn_location.rotation + PI / 2 # Mob direction perpendicular to path direction

	mob.position = mob_spawn_location.position # Sets mob position to spawn position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction # Go a random direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction) # Go a random velocity

	add_child(mob) # Spawn by adding to main scene

	print("Added banana child") # For testing purposes to see if/when code breaks clearer

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	print("StartTimer timed out") # For testing purposes to see if/when code breaks clearer
