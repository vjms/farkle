extends Control

var indicator = preload("res://UI/DiceIndication/DiceIndicator.tscn")

func reset():
	for child in $HBoxContainer.get_children():
		$HBoxContainer.remove_child(child)
		
		
func add_indicators(dice : Array):
	if dice.size() <= 0:
		return
	for d in dice:
		var inst = indicator.instance()
		inst.set_number(d.get_pointed_number())
		$HBoxContainer.add_child(inst)
	$HBoxContainer.add_constant_override("separation", $HBoxContainer.get_child(0).margin_right + 1)


