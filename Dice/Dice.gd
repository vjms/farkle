extends Spatial

onready var selection_indicator = $SelectionIndicator
onready var body = $RigidBody
var _is_selected = false


func _ready():
	selection_indicator.hide()
	Events.connect("dice_selected", self, "_on_selected")

func _on_selected(d):
	if d == body:
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
