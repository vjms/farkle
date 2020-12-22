extends Spatial

var dice_resource = preload("res://Dice/Dice.tscn")

var dice

func _ready():
	dice = dice_resource.instance()
	add_child(dice)
	dice.translation = $spawn.translation
	dice.throw(Vector3(-1, 0, 0))
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T:
			dice.throw(Vector3(-1, 0, 0))
			dice.translation = $spawn.translation
