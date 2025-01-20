extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Tchaff is ded :(")
	await $MessageTimer.timeout

	$Message.text = "Tchaff try again?"
	$Message.show()

	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(0.5).timeout
	$StartButton.show()
	$Guide.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func update_health(hp):
	var array = [":(", ":|", ":)", ":3"]
	$hpLabel.text = str(array[hp])

func _on_start_button_pressed():
	$StartButton.hide()
	$Guide.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
