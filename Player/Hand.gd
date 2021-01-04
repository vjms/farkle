extends Reference

var _dice: Array
var _score = 0
var _calculated = false
var _committed = false


func add_dice(dice):
	if not _committed and _dice.find(dice) == -1:
		_dice.append(dice)
		_calculated = false


func remove_dice(dice):
	if not _committed:
		var index = _dice.find(dice)
		_dice.remove(index)
		_calculated = false


func commit():
	_committed = true


func is_scoring_hand() -> bool:
	return _score > 0


func get_score() -> int:
	if not _calculated:
		_calculate_score()
	return _score


func get_dice_count() -> int:
	return _dice.size()


func _calculate_score():
	var counts = [0, 0, 0, 0, 0, 0]
	for d in _dice:
		counts[d.get_pointed_number() - 1] += 1
	_score = 0

	# check multiple sames:
	var index = 0
	for c in counts:
		index += 1
		match c:
			6:
				_score += _multiple_same_base_score(index) * 4
				counts[index - 1] = 0
			5:
				_score += _multiple_same_base_score(index) * 3
				counts[index - 1] = 0
			4:
				_score += _multiple_same_base_score(index) * 2
				counts[index - 1] = 0
			3:
				_score += _multiple_same_base_score(index)
				counts[index - 1] = 0

	# check full straight:
	_score += _straight(counts, 1, 6, 1500)

	# check small straight:
	_score += _straight(counts, 1, 5, 750)

	# check big straight
	_score += _straight(counts, 2, 6, 1000)

	# check singular:
	_score += counts[0] * 100  # ones
	_score += counts[4] * 50  # fives

	_calculated = true


func _straight(numbers, start, end, score):
	var returned_score = 0
	if _sum(numbers) >= (end - start) + 1:
		for n in range(start - 1, end):
			if numbers[n] == 0:
				break
			if n == end - 1:
				returned_score += score
				for i in range(start - 1, end):
					numbers[i] -= 1
	return returned_score


func _sum(array) -> int:
	var sum = 0
	for a in array:
		sum += a
	return sum


func _multiple_same_base_score(number):
	match number:
		1:
			return 1000
		2:
			return 200
		3:
			return 300
		4:
			return 400
		5:
			return 500
		6:
			return 600
	return 0

#######################################
# farkle scoring rules:

# 5 = 50
# 1 = 100

# triples:
# 1 = 1000
# 2 = 200
# 3 = 300
# 4 = 400
# 5 = 500
# 6 = 600

# quadruple -> value of triples * 2
# quintuple -> value of triples * 3
# sextuple -> value of triples * 4

# straight from 1 to 5 = 750
# straight from 2 to 5 = 1000
# straight from 1 to 6 = 1500

# special cases

#######################################
