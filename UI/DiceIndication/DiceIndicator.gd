extends Control


func set_number(number : int):
	if number >= 1 or number <= 6:
		$ItemList/Label.text = String(number)
