extends Spatial

var dice = preload("res://Dice/Dice.tscn")
onready var diceContainer = $DiceContainer

var spawns: Array
var restingDice: Array
var _all_dice_resting = false
var _throw_in_progress = false


func _ready():
	Events.connect("dice_resting", self, "_on_dice_resting")
	children_of_type(self, "SpawnLocation", spawns)


func children_of_type(parent, type, array):
	for child in parent.get_children():
		if type in child.get_name():
			array.append(child)
		children_of_type(child, type, array)


func _remove_dice():
	restingDice.clear()
	for child in diceContainer.get_children():
		diceContainer.remove_child(child)
		child.queue_free()
		

func throw_dice(count: int):
	if _throw_in_progress:
		return
	if count == 0:
		return
	if count > spawns.size():
		count = spawns.size()

	Events.emit_signal("dice_thrown")
	_throw_in_progress = true
	_remove_dice()

	for i in range(count):
		var inst = dice.instance()
		diceContainer.add_child(inst)
		inst.transform.origin = spawns[i].transform.origin

	for dice in diceContainer.get_children():
		dice.throw(Vector3(-1, 0, 0))



func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_T and event.pressed:
			throw_dice(6)


func _on_dice_resting(dice):
	if not dice.is_resting():
		var d = restingDice.find(dice)
		if d != -1:
			restingDice.remove(d)
	else:
		var index = restingDice.find(dice)
		if index == -1:
			restingDice.append(dice)
			_all_dice_resting = true
			for child in diceContainer.get_children():
				if restingDice.find(child) == -1:
					_all_dice_resting = false
					break
		else:
			restingDice.remove(index)
		if _all_dice_resting: 
			_throw_in_progress = false
			for d in diceContainer.get_children():
				d.set_can_be_selected(true)
			Events.emit_signal("all_dice_resting", diceContainer.get_children())
			var hand = load("res://Player/Hand.gd").new()
			for d in diceContainer.get_children():
				hand.add_dice(d)
			hand.get_score()
			hand.queue_free()

