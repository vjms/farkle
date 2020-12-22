extends Spatial

onready var selection_indicator = $SelectionIndicator
onready var body = $RigidBody
var is_selected = false


func _ready():
	selection_indicator.hide()

func _on_selected():
	is_selected = not is_selected
	if is_selected:
		selection_indicator.get_global_transform().translated(body.get_global_transform().basis.x)
		selection_indicator.show()
