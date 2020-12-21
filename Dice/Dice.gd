extends RigidBody

var gravity = Vector3(0.0, -98.1, 0.0)
var rng = RandomNumberGenerator.new()

#const face1 = Vector3(0, 10, 0)
#const face2 = Vector3(10, 0, 0)
#const face3 = Vector3(0, 0, 10)
#const face4 = Vector3(0, 0, -10)
#const face5 = Vector3(-10, 0, 0)
#const face6 = Vector3(0, -10, 0)


func _ready():
	rng.randomize()
	mass = 0.1
	throw(Vector3(-1, 0, 0))


func throw(direction: Vector3):
	var power = rng.randf_range(5, 10)
	var rot = rng.randf_range(-0.05, 0.05)
	rotate(Vector3(rng.randi_range(0, 1), rng.randi_range(0, 1), rng.randi_range(0, 1)), rng.randf_range(-90, 90))
	apply_impulse(Vector3(0.00, -0.01, rot), direction * power)
	pass


func get_pointed_number():
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


func _process(delta):
	pass


func _physics_process(delta):
	add_central_force(gravity * delta)
	print(get_pointed_number())
