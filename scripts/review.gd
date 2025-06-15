extends Control

var deck: Deck
var current_card: Card
var card_index: int = 0

func _ready():
	deck = get_node("/root/Main").current_deck
	load_next_card()

func load_next_card():
	if card_index < deck.cards.size():
		current_card = deck.cards[card_index]
		$Question.text = current_card.front
		$Answer.text = current_card.back
		$Answer.visible = false
		$RatingButtons.visible = false

func _on_ShowAnswer_pressed():
	$Answer.visible = true
	$RatingButtons.visible = true

func _on_rating_pressed(rating: int):
	update_card(rating)
	card_index += 1
	if card_index >= deck.cards.size():
		end_session()
	else:
		load_next_card()

func update_card(rating: int):
	# SM-2 Algorithm
	var q = rating  # 0-4 scale
	current_card.easiness = max(1.3, current_card.easiness + 0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
	
	if rating < 3:
		current_card.interval = 1
	else:
		current_card.interval = ceil(current_card.interval * current_card.easiness)
	
	current_card.due_date = OS.get_unix_time() + current_card.interval * 86400

func end_session():
	get_tree().change_scene("res://scenes/main.tscn")
