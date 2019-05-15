extends Node

onready var message = $message
onready var button_right = $right

var guess
var min_guessed = 0
var max_guessed = 1000
var ended = false

func _ready():
	calculate_guess()
	message.text = ''
	first_playthrough_checker()
	text_printer("Ill guess any number that you think between "+ str(min_guessed) +" and " + str(max_guessed))
	button_right.text = "Start"
	show_correctional_buttons(false)
func first_playthrough_checker():
	if globals.first_playthrough:
		text_printer("Hello from Number Guesser!\n\n")

func _process(delta):
	var up = "up"
	var down = "down"
	if button_right.text == "Correct":
		if Input.is_action_just_pressed(up):
			_try_guess(up)
		elif Input.is_action_just_pressed(down):
			_try_guess(down)
	if Input.is_action_just_pressed("continue"):
		if button_right.text == "Start":
			_on_right_pressed()
		else:
			check_end_game()
	if Input.is_action_just_pressed("close"):
		get_tree().quit()

#type up = greater or down = lesser
func _try_guess(type):
	if type == "up":
		min_guessed = guess
	else:
		max_guessed = guess
	calculate_guess()
	text_printer("guess")

func text_printer(print_text):
	if print_text == "guess":
		message.text = "Is " + str(guess) + " your number?"
	elif print_text == "guess_right":
		message.text = "Yes! I knew it! Your number was: " + str(guess) + "!"
	else:
		message.text += print_text

func calculate_guess():
	guess = (min_guessed + max_guessed) / 2

func _end_game():
	ended = true
	text_printer("guess_right")
	button_right.rect_position.x -= 50
	button_right.text = "Restart game"
	show_correctional_buttons(false)
	
func _restart_game():
	if globals.first_playthrough:
		globals.first_playthrough = false
	print(get_tree().reload_current_scene())

func check_end_game():
	if ended:
		_restart_game()
	else:
		_end_game()

func _on_greater_pressed():
	_try_guess("up")

func _on_lesser_pressed():
	_try_guess("down")

func _on_right_pressed():
	if button_right.text == "Start":
		text_printer("guess")
		button_right.text = "Correct"
		show_correctional_buttons(true)
	else:
		check_end_game()

func show_correctional_buttons(show):
	if show:
		$greater.show()
		$lesser.show()
	else:
		$greater.hide()
		$lesser.hide()
