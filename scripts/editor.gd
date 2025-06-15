extends Control

var deck: Deck
var current_card: Card
var card_index: int = 0

func _ready():
	deck = get_node("/root/Main").current_deck
	load_next_card()

func load_next_card():
	var due_cards = []
	for card in deck.cards:
		if card.due_date <= Time.get_unix_time_from_system():
			due_cards.append(card)
	
	if due_cards.size() > 0:
		current_card = due_cards[0]
		# ... rest of loading logic
	else:
		end_session()

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
	current_card.due_date = Time.get_unix_time_from_system() + current_card.interval * 86400	

func end_session():
	get_tree().change_scene("res://scenes/main.tscn")
