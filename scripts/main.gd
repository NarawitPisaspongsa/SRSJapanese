extends Control

const SAVE_PATH = "user://decks.json"
var decks: Array = []

func _ready():
	# Connect buttons using code
	%NewDeck.pressed.connect(_on_NewDeck_pressed)
	%Study.pressed.connect(_on_Study_pressed)
	
	# If you have Add Card button
	if has_node("AddCard"):
		%AddCard.pressed.connect(_on_AddCard_pressed)

func save_decks():
	var data = []
	for deck in decks:
		var deck_data = {
			"name": deck.name,
			"cards": []
		}
		for card in deck.cards:
			deck_data.cards.append({
				"front": card.front,
				"back": card.back,
				"interval": card.interval,
				"easiness": card.easiness,
				"due_date": card.due_date
			})
		data.append(deck_data)
	
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		if file:
			file.store_line(JSON.stringify(data))
			file.close()

func load_decks():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var text = file.get_as_text()
			var result = JSON.parse_string(text)
			file.close()
			
			if result != null:
				for deck_data in result:
					var deck = Deck.new()
					deck.name = deck_data["name"]
					for card_data in deck_data["cards"]:
						var card = Card.new()
						card.front = card_data["front"]
						card.back = card_data["back"]
						card.interval = card_data["interval"]
						card.easiness = card_data["easiness"]
						card.due_date = card_data["due_date"]
						deck.cards.append(card)
					decks.append(deck)
					$DeckList.add_item(deck.name)
