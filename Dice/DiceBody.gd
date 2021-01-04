extends RigidBody


var gravity = Vector3(0.0, -98.1, 0.0)
var rng = RandomNumberGenerator.new()

var timer = Timer.new()
var _resting = false setget _set_resting, is_resting

signal selected
signal resting


func _set_resting(new_val):
	_resting = new_val
	emit_signal("resting")


func is_resting():
	return _resting


func _ready():
	timer.connect("timeout", self, "_on_physics_stop_timeout")
	add_child(timer)
	rng.randomize()
	set_mass(0.1)


func throw(direction: Vector3):
	_set_resting(false)
	set_linear_velocity(Vector3())
	set_angular_velocity(Vector3())
	var power = rng.randf_range(5, 7)
	var rot = rng.randf_range(-0.03, 0.03)
	match rng.randi_range(1, 3):
		1:
			rotate(Vector3(1, 0, 0), rng.randf_range(PI / 2.0, 2.0 * PI))
		2:
			rotate(Vector3(0, 1, 0), rng.randf_range(PI / 2.0, 2.0 * PI))
		3:
			rotate(Vector3(0, 0, 1), rng.randf_range(PI / 2.0, 2.0 * PI))
	apply_impulse(Vector3(0.0, 0.0, rot), direction * power)
	apply_impulse(Vector3(0.0, -1, 0), direction * 1)


func get_pointed_number() -> int:
	var t = get_global_transform().basis
	var face1 = t.y
	var face2 = t.x
	var face3 = t.z
	var face4 = -t.z
	var face5 = -t.x
	var face6 = -t.y
	var up = Vector3(0, 1, 0)
	return 1 + minindex([up.angle_to(face1), up.angle_to(face2), up.angle_to(face3), up.angle_to(face4), up.angle_to(face5), up.angle_to(face6)])


func minindex(array: Array):
	var i = 0
	var c = 0
	for a in array:
		if a < array[c]:
			c = i
		i += 1
	return c


func _physics_process(delta):
	if not _resting:
		add_central_force(gravity * delta)
		if get_linear_velocity().length() < 0.1:
			if timer.is_stopped():
				timer.set_one_shot(true)
				timer.start(0.4)
		else:
			timer.stop()


func _on_physics_stop_timeout():
	_set_resting(true)


func _on_Dice_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == BUTTON_LEFT:
			emit_signal("selected")
