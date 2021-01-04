extends Spatial

var dice_preload = preload("res://Dice/Dice.tscn")

onready var diceContainer = $DiceContainer
onready var spawns = $Spawns

var restingDice: Array
var _all_dice_resting = false
var _throw_in_progress = false


func _ready():
	Events.connect("dice_resting", self, "_on_dice_resting")
	Farkle.board = self


func _remove_dice():
	restingDice.clear()
	for child in diceContainer.get_children():
		diceContainer.remove_child(child)
		child.queue_free()

func get_dice() -> Array:
	return diceContainer.get_children()

func throw_dice(count: int):
	if _throw_in_progress or count == 0:
		return
	if count > spawns.get_child_count():
		count = spawns.get_child_count()

	Events.emit_signal("dice_thrown")
	_throw_in_progress = true
	_remove_dice()

	for i in range(count):
		var inst = dice_preload.instance()
		diceContainer.add_child(inst)
		inst.transform.origin = spawns.get_child(i).transform.origin

	for d in diceContainer.get_children():
		d.throw(Vector3(-1, 0, 0))
	


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
