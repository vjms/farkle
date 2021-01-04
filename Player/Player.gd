extends Spatial

var score = 0
var round_hands = Array()
var hand_resource_loc = "res://Player/Hand.gd"
var current_hand
var max_throwable_dice = 6
var total_selected_dice = 0

func _ready():
	Events.connect("dice_selected", self, "_dice_selected")


func get_round_total() -> int:
	var tmp = 0
	for h in round_hands:
		tmp += h.get_score()
	return tmp


func throw():
	current_hand = load(hand_resource_loc).new()
	round_hands.append(current_hand)
	if total_selected_dice >= max_throwable_dice:
		total_selected_dice = 0
	Farkle.board.throw_dice(max_throwable_dice - total_selected_dice)


func _input(event):
	if event is InputEventKey:
		if not event.pressed:
			return
		match event.scancode:
			KEY_T:
				throw()
			KEY_ENTER:
				_commit_hand()


func _commit_hand():
	current_hand.commit()
	print(current_hand.get_score(), " ", get_round_total())
	total_selected_dice += current_hand.get_dice_count()


func _dice_selected(dice):
	if dice.is_selected():
		current_hand.add_dice(dice)
	else:
		current_hand.remove_dice(dice)
