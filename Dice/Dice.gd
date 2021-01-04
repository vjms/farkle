extends Spatial

onready var selection_indicator = $SelectionIndicator
onready var body = $RigidBody
var _is_selected = false
var _can_be_selected = false


func _ready():
	selection_indicator.hide()
	body.connect("resting", self, "_on_body_resting")
	body.connect("selected", self, "_on_selected")

func _on_body_resting():
	Events.emit_signal("dice_resting", self)

func is_resting():
	return body.is_resting()

func _on_selected():
	Events.emit_signal("dice_selected", self)
	if _can_be_selected:
		_is_selected = !_is_selected
		if _is_selected:
			selection_indicator.transform.origin = body.transform.origin
			selection_indicator.show()
		else:
			selection_indicator.hide()

func throw(direction: Vector3):
	body.throw(direction)

func get_pointed_number() -> int:
	return body.get_pointed_number()

func set_can_be_selected(new_val: bool):
	_can_be_selected = new_val
	if !new_val:
		selection_indicator.hide()
