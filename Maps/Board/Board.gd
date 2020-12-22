extends Spatial

var dice = preload("res://Dice/Dice.tscn")
onready var diceContainer = $DiceContainer
onready var diceIndicator = $DiceSelectionRow

var spawns: Array
var selectedDice: Array



func _ready():
	Events.connect("dice_selected", self, "_on_dice_selected")

	children_of_type(self, "SpawnLocation", spawns)

	for i in range(6):
		var inst = dice.instance()
		diceContainer.add_child(inst)
		inst.transform.origin = spawns[i].transform.origin

	for dice in diceContainer.get_children():
		dice.throw(Vector3(-1, 0, 0))


func children_of_type(parent, type, array):
	for child in parent.get_children():
		children_of_type(child, type, array)
		if type in child.get_name():
			array.append(child)


func _on_dice_selected(dice):
	var index = selectedDice.find(dice)
	if index == -1:
		selectedDice.append(dice)
	else:
		selectedDice.remove(index)
	diceIndicator.reset()
	diceIndicator.add_indicators(selectedDice)

